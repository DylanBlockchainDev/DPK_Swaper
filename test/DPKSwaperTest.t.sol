// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test, console} from "../lib/forge-std/src/Test.sol";
import {DPKSwaper} from "../src/DPKSwaper.sol";
import {ISwapRouter} from "../lib/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import {IUniswapV3Pool} from "../lib/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import {ReentrancyGuard} from "../lib/openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol";
import {MockISwapRouter} from "../test/mocks/MockISwapRouter.sol"; 
import {ERC20Mock} from "../lib/openzeppelin-contracts/contracts/mocks/token/ERC20Mock.sol";
// import {MockIERC20} from "../test/mocks/MockIERC20.sol";

contract DPKSwaperTest is Test {
    DPKSwaper dpkSwaper;
    // MockIERC20 tokenIn;
    // MockIERC20 tokenOut;
    ERC20Mock tokenIn;
    ERC20Mock tokenOut;
    MockISwapRouter swapRouter;

    event SwapInput(
        address indexed tokenIn,
        address indexed tokenOut,
        uint256 amountIn,
        uint256 amountOut
    );
    
    event SwapOutput(
        address indexed tokenIn,
        address indexed tokenOut,
        uint256 amountIn,
        uint256 amountOut
    );

    function setUp() public {
        tokenIn = new ERC20Mock();
        tokenOut = new ERC20Mock();
        swapRouter = new MockISwapRouter();

        dpkSwaper = new DPKSwaper(address(swapRouter));
    }

    function testSwapExactInputSingle() public {
        // Mint some tokens for the sender to use in the swap
        tokenIn.mint(address(this), 10000 ether);
        tokenOut.mint(address(this), 2000 ether);

        // Define the swap parameters
        address tokenInAddress = address(tokenIn);
        address tokenOutAddress = address(tokenOut);
        uint256 amountIn = 5000 ether; // Amount of tokenIn to swap

        // Call the swap function to get the amountOut value
        uint256 amountOut = dpkSwaper.swapExactInputSingle(tokenInAddress, tokenOutAddress, amountIn);

        // Use vm.expectEmit to assert the event was emitted with the correct values
        vm.expectEmit(true, true, false, true);
        emit SwapInput({tokenIn: tokenInAddress, tokenOut: tokenOutAddress, amountIn: amountIn, amountOut: amountOut});
        
        // Re-call the swap function for the actual operation
        dpkSwaper.swapExactInputSingle(tokenInAddress, tokenOutAddress, amountIn);
        
        // Verify the swap result
        assertEq(amountOut, 5000 ether, "Incorrect amount of tokenOut received");
    }


    function testSwapExactOutputSingle() public { 
        // Mint some tokens for the sender to use in the swap
        tokenIn.mint(address(this), 10000 ether);
        tokenOut.mint(address(this), 2000 ether);

        // Define the swap parameters
        address tokenInAddress = address(tokenIn);
        address tokenOutAddress = address(tokenOut);
        uint256 amountOut = 500 ether; // Target amount of tokenOut
        uint256 amountInMaximum = 1000 ether; // Maximum amount of tokenIn to spend

        // Call the swap function to get the amountIn value
        uint256 amountIn = dpkSwaper.swapExactOutputSingle(tokenInAddress, tokenOutAddress, amountOut, amountInMaximum);

        // Use vm.expectEmit to assert the event was emitted with the correct values
        vm.expectEmit(true, true, false, true);
        emit SwapOutput({tokenIn: tokenInAddress, tokenOut: tokenOutAddress, amountIn: amountIn, amountOut: amountOut});

        // Re-call the swap function for the actual operation
        dpkSwaper.swapExactOutputSingle(tokenInAddress, tokenOutAddress, amountOut, amountInMaximum);
        
        // Verify the swap result
        // assertGt(amountIn, 0, "Expected to spend some tokenIn");
        // assertLt(amountIn, amountInMaximum, "Spent more tokenIn than allowed");
    }
    
}
