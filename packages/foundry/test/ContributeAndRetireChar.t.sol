import "forge-std/Test.sol";
import "../src/FundingPool.sol";

interface IFaucet {
    function withdraw(address erc20Address, uint256 amount) external;
}

contract ContributeTest is Test {
    uint256 baseSepoliaFork;

    // all addresses for the deployment on Base Sepolia
    address constant CHAR_TOKEN = 0xf92f74Dd03f9A9E04773cE5fF3BCeaBB2eB1dDf0;
    address constant CHAR_FAUCET = 0xf2a25A2b3C9652A3Eb32f7fe18CBf58E664Fd054;
    address constant TCO2_TOKEN = 0xd0844B61Dcd657EE937D3CD8cF0a4b83a87218cD;

    function setUp() public {
        string memory BASE_SEPOLIA_RPC_URL = vm.envString("BASE_SEPOLIA_RPC_URL");
        baseSepoliaFork = vm.createFork(BASE_SEPOLIA_RPC_URL);
    }

    function testContribute() public {
        vm.selectFork(baseSepoliaFork);
        assertEq(vm.activeFork(), baseSepoliaFork);

        FundingPool fundingPool = new FundingPool(CHAR_TOKEN);

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
}