//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "forge-std/console.sol";

import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import {CCIPReceiver} from "@chainlink/contracts-ccip/src/v0.8/ccip/applications/CCIPReceiver.sol";
import {RegenServiceManager} from "./RegenServiceManager.sol";
import {RegenPledgeRegistry} from "./RegenPledgeRegistry.sol";

contract RegenChallengeManager is CCIPReceiver {

    RegenServiceManager public serviceManager;
    RegenPledgeRegistry public pledgeRegistry;

    uint256 constant ETH_CHAR_TOKENS_PER_EPOCH = 154 ether; // 2000 / 13 * 1000

    constructor(address _router, RegenPledgeRegistry _pledgeRegistry) CCIPReceiver(_router) {
        pledgeRegistry = _pledgeRegistry;
    }

    function initialize(address _serviceManager) public {
        serviceManager = RegenServiceManager(_serviceManager);
    }

    function _ccipReceive(Client.Any2EVMMessage memory message) internal override {
        console.logBytes(message.data);

        (address operator, uint256 epoch, uint256 amount) = abi.decode(message.data, (address, uint256, uint256));

        // check the pledge registry to see if the challenge is valid and should result in slashing
        uint256 pledge = pledgeRegistry.pledges(operator);

        uint256 expectedAmount = pledge * ETH_CHAR_TOKENS_PER_EPOCH / 1 ether;

        // if the pledge is less than the amount of carbon offset then the operator is slashed
        if (expectedAmount < amount) {
            serviceManager.freezeOperator(operator);
        }
    }
}
