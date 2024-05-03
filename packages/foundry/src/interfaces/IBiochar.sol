// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

interface IBiochar {
    function redeemOutMany(
        address[] calldata tco2s,
        uint256[] calldata amounts,
        uint256 maxFee
    ) external returns (uint256 poolAmountSpent);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    function balanceOf(address account) external view returns (uint256);
}
