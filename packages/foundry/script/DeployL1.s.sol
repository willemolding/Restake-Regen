//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "forge-std/Script.sol";
import "forge-std/Test.sol";

import {Deployer_M2} from "@eigenlayer-scripts/deploy/devnet/M2_Deploy_From_Scratch.s.sol";
import "@eigenlayer-middleware/src/ServiceManagerBase.sol";
import {Utils} from "./utils/Utils.sol";

import {IDelegationManager} from "@eigenlayer/contracts/interfaces/IDelegationManager.sol";
import {IAVSDirectory} from "@eigenlayer/contracts/interfaces/IAVSDirectory.sol";
import {IStrategyManager, IStrategy} from "@eigenlayer/contracts/interfaces/IStrategyManager.sol";
import {ISlasher} from "@eigenlayer/contracts/interfaces/ISlasher.sol";
import {StrategyBaseTVLLimits} from "@eigenlayer/contracts/strategies/StrategyBaseTVLLimits.sol";

import "../src/RegenChallengeManager.sol";
import "../src/RegenPledgeRegistry.sol";
import "../src/RegenServiceManager.sol";

contract DeployPreconf is Script, Utils {
    address constant L1_CCIP_ROUTER =
        0x0BF3dE8c5D3e8A2B34D2BEeB17ABfCeBaf363A59;

    function run() public {
        // First deploy an instance of Eigenlayer to our testnet and grab handles the the contracts
        Deployer_M2 deployer = new Deployer_M2();
        deployer.run("M2_deployment.config.json");

        string memory eigenlayerDeployedContracts = readOutput(
            "M2_from_scratch_deployment_data"
        );
        IStrategyManager strategyManager = IStrategyManager(
            stdJson.readAddress(
                eigenlayerDeployedContracts,
                ".addresses.strategyManager"
            )
        );
        IDelegationManager delegationManager = IDelegationManager(
            stdJson.readAddress(
                eigenlayerDeployedContracts,
                ".addresses.delegation"
            )
        );
        IAVSDirectory avsDirectory = IAVSDirectory(
            stdJson.readAddress(
                eigenlayerDeployedContracts,
                ".addresses.avsDirectory"
            )
        );

        // Next deploy out AVS contracts and register them
        // with the Eigenlayer instance
        RegenChallengeManager challengeManager = new RegenChallengeManager(
            L1_CCIP_ROUTER
        );
        RegenPledgeRegistry pledgeManager = new RegenPledgeRegistry();
        // RegenServiceManager serviceManager = new RegenServiceManager(
        //     avsDirectory,
        //     registryCoordinator,
        //     stakeRegistry,
        //     challengeManager
        // );
    }
}
