// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

interface IBiochar {
    function redeemOutMany(
        address[] memory tco2s,
        uint256[] memory amounts,
        uint256 maxFee
    ) external returns (uint256 poolAmountSpent);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
}
