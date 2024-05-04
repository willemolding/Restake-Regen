// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./CreateRetirementRequestParams.sol";

interface IToucanCarbonOffset {
    function requestRetirement(CreateRetirementRequestParams calldata params)
        external
        returns (uint256 requestId);
}
