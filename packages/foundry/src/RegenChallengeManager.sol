//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "forge-std/console.sol";

import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import {CCIPReceiver} from "@chainlink/contracts-ccip/src/v0.8/ccip/applications/CCIPReceiver.sol";

contract RegenChallengeManager is CCIPReceiver {

    address public serviceManager;

    constructor(address _router, address _serviceManager) CCIPReceiver(_router) {
        serviceManager = _serviceManager;
    }

    function _ccipReceive(Client.Any2EVMMessage memory message) internal override {
        console.logBytes(message.data);
    }
}
