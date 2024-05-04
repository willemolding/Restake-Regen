//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract RegenPledgeRegistry {

    mapping(address => uint256) public pledges;

    function makePledge(
        address operator, // address of the operator making the pledge
        uint256 amount // fraction of the network this operator wants to offset. This is encoded such that 1e18 is 100%
    ) public {
        // in the proper implementation this will first check the operator is
        // registered with Eigenlayer and has been delegated the required amount of stake

        pledges[operator] = amount;
    }
}
