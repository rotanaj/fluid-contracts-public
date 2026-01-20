pragma solidity ^0.8.21;

import "forge-std/Test.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IFluidLiquidity {
    function operate(address token, int256 supply, int256 borrow, address withdrawTo, address borrowTo, bytes calldata data) external returns (uint256);
    function getExchangePricesAndConfig(address token) external view returns (uint256);
}

contract TotiAudit is Test {
    IFluidLiquidity fluid = IFluidLiquidity(0x52Aa899454998Be5b000Ad077a46Bbe360F4e497);
    // Derleyicinin dikte ettigi checksum'li USDC adresi:
    address constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    function setUp() public {
        vm.createSelectFork("https://ethereum-rpc.publicnode.com");
    }

    function test_TotiExploit() public {
        console.log("--- SHERLOCK ANALIZI: NIHAI ATESLEME ---");
        deal(USDC, address(this), 10_000 * 1e6);
        IERC20(USDC).approve(address(fluid), type(uint256).max);
        
        // Repay yaparak callback zorluyoruz
        fluid.operate(USDC, 0, -100 * 1e6, address(this), address(this), abi.encode(address(this)));
    }

    function liquidityCallback(address token, uint256 amount, bytes calldata data) external {
        uint256 slotInside = fluid.getExchangePricesAndConfig(token);
        // Veriyi string olarak hata mesajina gomuyoruz ki terminalde gorunsum
        revert(vm.toString(slotInside));
    }
}