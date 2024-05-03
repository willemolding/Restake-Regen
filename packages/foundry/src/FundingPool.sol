//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "@toucanprotocol/contracts/pools/Biochar.sol";
import "@toucanprotocol/contracts/interfaces/IToucanCarbonOffsets.sol";

import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";

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
   
    Biochar public charToken;


    // stores the contributions made for a given epoch by a given contributor
    // contributor => epoch => value
    mapping(address => mapping(uint256 => uint256)) public contributions;

    constructor(address _tokenAddress) {
        charToken = Biochar(_tokenAddress);
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
            IToucanCarbonOffsets(tco2s[i]).burnFrom(address(this), amounts[i]);
        }
    }

    function challenge() external {

    }

    //////////////////////////////////
    // Internal functions
    //////////////////////////////////

    function currentEpoch() internal view returns (uint256) {
        return (block.timestamp / EPOCH_SECONDS);
    }
}
