// SPDX-License-Identifier: MIT
pragma solidity =0.8.12;

import "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";

import "@eigenlayer/contracts/permissions/PauserRegistry.sol";
import {IDelegationManager} from "@eigenlayer/contracts/interfaces/IDelegationManager.sol";
import {IAVSDirectory} from "@eigenlayer/contracts/interfaces/IAVSDirectory.sol";
import {IStrategyManager, IStrategy} from "@eigenlayer/contracts/interfaces/IStrategyManager.sol";
import {ISlasher} from "@eigenlayer/contracts/interfaces/ISlasher.sol";
import {StrategyBaseTVLLimits} from "@eigenlayer/contracts/strategies/StrategyBaseTVLLimits.sol";
import "@eigenlayer/test/mocks/EmptyContract.sol";

import "@eigenlayer-middleware/src/RegistryCoordinator.sol" as regcoord;
import {IBLSApkRegistry, IIndexRegistry, IStakeRegistry} from "@eigenlayer-middleware/src/RegistryCoordinator.sol";
import {BLSApkRegistry} from "@eigenlayer-middleware/src/BLSApkRegistry.sol";
import {IndexRegistry} from "@eigenlayer-middleware/src/IndexRegistry.sol";
import {StakeRegistry} from "@eigenlayer-middleware/src/StakeRegistry.sol";
import "@eigenlayer-middleware/src/OperatorStateRetriever.sol";

import {RegenServiceManager} from "../src/RegenServiceManager.sol";
import {RegenPledgeRegistry} from "../src/RegenPledgeRegistry.sol";
import {RegenChallengeManager} from "../src/RegenChallengeManager.sol";

import {IWorldID} from "../src/interfaces/IWorldID.sol";

import "../src/ERC20Mock.sol";

import {Utils} from "./utils/Utils.sol";

import "forge-std/Test.sol";
import "forge-std/Script.sol";
import "forge-std/StdJson.sol";
import "forge-std/console.sol";

import "./DeployHelpers.s.sol";


// # To deploy and verify our contract
contract DeployL1 is ScaffoldETHDeploy {
    address constant L1_CCIP_ROUTER = 0x0BF3dE8c5D3e8A2B34D2BEeB17ABfCeBaf363A59;
    address constant WORLD_ID_ROUTER = 0x469449f251692E0779667583026b5A1E99512157;
    string constant appId = "app_staging_64d94c0a4c6d65f0a63e059939e58887";
    string constant actionId = "register-for-restakeregen";
    // ERC20 and Strategy: we need to deploy this erc20, create a strategy for it, and whitelist this strategy in the strategymanager

    ERC20Mock public erc20Mock;
    StrategyBaseTVLLimits public erc20MockStrategy;

    regcoord.RegistryCoordinator public registryCoordinator;
    regcoord.IRegistryCoordinator public registryCoordinatorImplementation;

    IBLSApkRegistry public blsApkRegistry;
    IBLSApkRegistry public blsApkRegistryImplementation;

    IIndexRegistry public indexRegistry;
    IIndexRegistry public indexRegistryImplementation;

    IStakeRegistry public stakeRegistry;
    IStakeRegistry public stakeRegistryImplementation;

    OperatorStateRetriever public operatorStateRetriever;

    function run() external {
        vm.startBroadcast();
        _deployRestakeRegenContracts();
        vm.stopBroadcast();
    }

    function _deployRestakeRegenContracts() internal {

        RegenPledgeRegistry regenPledgeRegistry = new RegenPledgeRegistry(IWorldID(WORLD_ID_ROUTER), appId, actionId);
        deployments.push(ScaffoldETHDeploy.Deployment("RegenPledgeRegistry", address(regenPledgeRegistry)));

        RegenChallengeManager regenChallengeManager = new RegenChallengeManager(L1_CCIP_ROUTER, regenPledgeRegistry);
        deployments.push(ScaffoldETHDeploy.Deployment("RegenChallengeManager", address(regenChallengeManager)));

        RegenServiceManager regenServiceManager = new RegenServiceManager(regenChallengeManager);
        deployments.push(ScaffoldETHDeploy.Deployment("RegenServiceManager", address(regenServiceManager)));
        regenChallengeManager.initialize(address(regenServiceManager));


        exportDeployments();
    }
}
