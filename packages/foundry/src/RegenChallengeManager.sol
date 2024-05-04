//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "forge-std/console.sol";

import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import {CCIPReceiver} from "@chainlink/contracts-ccip/src/v0.8/ccip/applications/CCIPReceiver.sol";
import {RegenServiceManager} from "./RegenServiceManager.sol";

contract RegenChallengeManager is CCIPReceiver {

    RegenServiceManager public serviceManager;

    constructor(address _router, address _serviceManager) CCIPReceiver(_router) {
        serviceManager = RegenServiceManager(_serviceManager);
    }

    function _ccipReceive(Client.Any2EVMMessage memory message) internal override {
        console.logBytes(message.data);

        (address operator, uint256 epoch, uint256 amount) = abi.decode(message.data, (address, uint256, uint256));

        // check the pledge registry to see if the challenge is valid and should result in slashing


        // if so make a slash
        // serviceManager.freezeOperator(operator);
    }
}
