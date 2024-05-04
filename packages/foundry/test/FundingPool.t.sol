pragma solidity >=0.8.0 <0.9.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../src/FundingPool.sol";
import "../src/RegenChallengeManager.sol";

import {CCIPLocalSimulatorFork} from "@chainlink/local/src/ccip/CCIPLocalSimulatorFork.sol";

interface IFaucet {
    function withdraw(address erc20Address, uint256 amount) external;
}

contract ContributeTest is Test {
    uint256 sepoliaFork;
    uint256 baseSepoliaFork;

    CCIPLocalSimulatorFork ccipLocalSimulatorFork;

    // all addresses for the deployment on Base Sepolia
    address constant CHAR_TOKEN = 0xf92f74Dd03f9A9E04773cE5fF3BCeaBB2eB1dDf0;
    address constant CHAR_FAUCET = 0xf2a25A2b3C9652A3Eb32f7fe18CBf58E664Fd054;
    address constant TCO2_TOKEN = 0xd0844B61Dcd657EE937D3CD8cF0a4b83a87218cD;

    address constant L1_CCIP_ROUTER = 0x0BF3dE8c5D3e8A2B34D2BEeB17ABfCeBaf363A59;
    address constant BASE_CCIP_ROUTER = 0xD3b06cEbF099CE7DA4AcCf578aaebFDBd6e88a93;
    uint64 constant L1_CHAIN_SELECTOR = 16015286601757825753;

    function setUp() public {
        string memory BASE_SEPOLIA_RPC_URL = vm.envString("BASE_SEPOLIA_RPC_URL");
        baseSepoliaFork = vm.createFork(BASE_SEPOLIA_RPC_URL);

        string memory SEPOLIA_RPC_URL = vm.envString("SEPOLIA_RPC_URL");
        sepoliaFork = vm.createFork(SEPOLIA_RPC_URL);

        ccipLocalSimulatorFork = new CCIPLocalSimulatorFork();
        vm.makePersistent(address(ccipLocalSimulatorFork));
    }

    function testContributeAndRetire() public {
        vm.selectFork(baseSepoliaFork);
        assertEq(vm.activeFork(), baseSepoliaFork);

        FundingPool fundingPool = new FundingPool(CHAR_TOKEN, BASE_CCIP_ROUTER, address(0), L1_CHAIN_SELECTOR);

        // get some CHAR from the faucet
        IFaucet(CHAR_FAUCET).withdraw(CHAR_TOKEN, 5 ether);

        // deposit it into the funding pool
        IERC20(CHAR_TOKEN).approve(address(fundingPool), 5 ether);
        fundingPool.contribute(address(this), 5 ether, address(this));

        // check that the contribution was recorded (TODO)

        // Reture the CHAR in the pool
        address[] memory tokens = new address[](1);
        tokens[0] = TCO2_TOKEN;
        uint256[] memory amounts = new uint256[](1);
        amounts[0] = 1 ether;
        fundingPool.retire(tokens, amounts, type(uint256).max);
    }

    function testChallenge() public {
        // deploy the receiver on L1
        vm.selectFork(sepoliaFork);
        assertEq(vm.activeFork(), sepoliaFork);

        RegenChallengeManager RegenchallengeManager = new RegenChallengeManager(L1_CCIP_ROUTER, address(0));

        vm.selectFork(baseSepoliaFork);
        assertEq(vm.activeFork(), baseSepoliaFork);

        FundingPool fundingPool = new FundingPool(CHAR_TOKEN, BASE_CCIP_ROUTER, address(RegenchallengeManager), L1_CHAIN_SELECTOR);
        fundingPool.challenge{value: 1 ether}(address(this), 0);

        console.log("Challenge sent");

        ccipLocalSimulatorFork.switchChainAndRouteMessage(sepoliaFork);
    }
}
