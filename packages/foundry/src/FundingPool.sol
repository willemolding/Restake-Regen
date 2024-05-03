//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import {IBiochar} from "./interfaces/IBiochar.sol";

import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import {IRouterClient} from "@chainlink/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol";

interface IERC20 {
    function approve(address spender, uint256 amount) external returns (bool);
}

/**
 * @title FundingPool
 * @dev Participants and contribute CHAR tokens and this contract records value in the epoch it was made.
 *      Once an epoch has ended no more contributions can be made.
 *      The contract can be challenged by a participant if they believe the contributions are incorrect.
 * @author Wollum
 */
contract FundingPool {
    uint256 public constant EPOCH_SECONDS = 2419200;
   
    IBiochar public charToken;
    address public ccipRouter;
    address public challengeReceiver;
    uint64 public destinationChain;

    // stores the contributions made for a given epoch by a given contributor
    // contributor => epoch => value
    mapping(address => mapping(uint256 => uint256)) public contributions;

    error NotEnoughBalance(uint256 currentBalance, uint256 calculatedFees); // Used to make sure contract has enough balance.

    constructor(address _tokenAddress, address _ccipRouter, address _challengeReceiver, uint64 _destinationChain) {
        charToken = IBiochar(_tokenAddress);
        ccipRouter = _ccipRouter;
        challengeReceiver = _challengeReceiver;
        destinationChain = _destinationChain;
    }

    //////////////////////////////////
    // External functions
    //////////////////////////////////

    // Contribute pool tokens to the pool and have a record made for the given epoch
    function contribute(
        address _from,
        uint256 _value,
        address _contributor
    ) external {
        require(
            charToken.transferFrom(_from, address(this), _value),
            "Transfer failed"
        );
        contributions[_contributor][currentEpoch()] += _value;
    }

    /// @notice Exchanges all CHAR tokens currently in the pool for tCO2 and then retires them
    /// TODO: It would be nice if it auto-retired the oldest projects first
    function retire(
        address[] calldata tco2s,
        uint256[] calldata amounts,
        uint256 maxFee
    ) external {
        charToken.redeemOutMany(tco2s, amounts, maxFee);
        for (uint256 i = 0; i < tco2s.length; i++) {
            IERC20(tco2s[i]).approve(address(this), amounts[i]);
            // TODO: get retirements working
            // IToucanCarbonOffsets(tco2s[i]).burnFrom(address(this), amounts[i]);
        }
    }


    function challenge(address contributor, uint256 epoch) external payable returns (bytes32) {
        Client.EVM2AnyMessage memory message = Client.EVM2AnyMessage({
            receiver: abi.encode(challengeReceiver),
            data: abi.encode(contributor, epoch, contributions[contributor][epoch]),
            tokenAmounts: new Client.EVMTokenAmount[](0),
            extraArgs: Client._argsToBytes(
                // Additional arguments, setting gas limit
                Client.EVMExtraArgsV1({gasLimit: 200_000})
            ),
            feeToken: address(0) // pay fees with native token
        });

        IRouterClient router = IRouterClient(ccipRouter);

        // Get the fee required to send the CCIP message
        uint256 fees = router.getFee(destinationChain, message);

        if (fees > address(this).balance)
            revert NotEnoughBalance(address(this).balance, fees);

        // Send the CCIP message through the router and store the returned CCIP message ID
        bytes32 messageId = router.ccipSend{value: fees}(
            destinationChain,
            message
        );

        return bytes32(messageId);
    }

    //////////////////////////////////
    // Internal functions
    //////////////////////////////////

    function currentEpoch() internal view returns (uint256) {
        return (block.timestamp / EPOCH_SECONDS);
    }
}
