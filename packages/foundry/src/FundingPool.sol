//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "forge-std/console.sol";

import {IBiochar} from "./interfaces/IBiochar.sol";
import {IToucanCarbonOffset} from "./interfaces/IToucanCarbonOffset.sol";
import {CreateRetirementRequestParams} from "./interfaces/CreateRetirementRequestParams.sol";

import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import {IRouterClient} from "@chainlink/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol";

interface IERC20 {
    function approve(address spender, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
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
        address _operator
    ) external {
        require(
            charToken.transferFrom(_from, address(this), _value),
            "Transfer failed"
        );
        contributions[_operator][currentEpoch()] += _value;
    }

    /// @notice Exchanges all CHAR tokens currently in the pool for tCO2 and then retires them
    /// TODO: It would be nice if it auto-retired the oldest projects first
    function retire(
        address[] calldata tco2s,
        uint256[] calldata amounts,
        uint256 maxFee
    ) external {
        charToken.redeemOutMany(tco2s, amounts, maxFee);

        console.log("CHAR Balance: %d", charToken.balanceOf(address(this)));

        for (uint256 i = 0; i < tco2s.length; i++) {
            console.log("TCO2 Balance: %d", IERC20(tco2s[i]).balanceOf(address(this)));
            // IToucanCarbonOffset(tco2s[i]).requestRetirement(
            //     CreateRetirementRequestParams({
            //         tokenIds: new uint256[](0),
            //         amount: amounts[i],
            //         retiringEntityString: "Restake//Regen",
            //         beneficiary: address(this),
            //         beneficiaryString: "Restake//Regen",
            //         retirementMessage: "Offsetting carbon emissions from the Restake//Regen project",
            //         beneficiaryLocation: "",
            //         consumptionCountryCode: "Ethereum",
            //         consumptionPeriodStart: block.timestamp - EPOCH_SECONDS,
            //         consumptionPeriodEnd: block.timestamp
            //     })
            // );
        }
    }


    function challenge(address operator, uint256 epoch) external payable returns (bytes32) {
        Client.EVM2AnyMessage memory message = Client.EVM2AnyMessage({
            receiver: abi.encode(challengeReceiver),
            data: abi.encode(operator, epoch, contributions[operator][epoch]),
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

    function currentEpoch() public view returns (uint256) {
        return (block.timestamp / EPOCH_SECONDS);
    }
}
