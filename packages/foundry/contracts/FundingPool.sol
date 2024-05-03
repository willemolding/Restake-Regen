//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@toucanprotocol/contracts/pools/biochar.sol";

/**
 * @title FundingPool
 * @dev Participants and contribute CHAR tokens and this contract records value in the epoch it was made.
 *      Once an epoch has ended no more contributions can be made.
 *      The contract can be challenged by a participant if they believe the contributions are incorrect.
 * @author Wollum
 */
contract FundingPool {

    uint256 public constant EPOCH_SECONDS = 2419200;
    ERC20 public charToken;

    // stores the contributions made for a given epoch by a given contributor
    // contributor => epoch => value
    mapping (address => mapping (uint256 => uint256)) public contributions;

    constructor(address _tokenAddress) {
        charToken = ERC20(_tokenAddress);
    }

    // Contribute pool tokens to the pool and have a record made for the given epoch
    function contribute(address _from, uint256 _value, address _contributor) external {
        require(charToken.transferFrom(_from, address(this), _value), "Transfer failed");
        contributions[_contributor][currentEpoch()] += _value;
    }

    function challenge() external {

    }

    function retire() external {

    }

    function currentEpoch() internal view returns (uint256) {
        return (block.timestamp / EPOCH_SECONDS);
    }

}
