//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "forge-std/Script.sol";
import "forge-std/Test.sol";

import {Deployer_M2} from "@eigenlayer-scripts/deploy/devnet/M2_Deploy_From_Scratch.s.sol";

contract DeployPreconf is Script {
    function run() public {
        Deployer_M2 deployer = new Deployer_M2();
        deployer.run("M2_deployment.config.json");
   }
}
