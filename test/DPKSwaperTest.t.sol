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

    function setUp() public {
        tokenIn = new ERC20Mock();
        tokenOut = new ERC20Mock();
        swapRouter = new MockISwapRouter();

        dpkSwaper = new DPKSwaper();

        tokenIn.mint(address(dpkSwaper), 10000 ether);
        tokenOut.mint(address(dpkSwaper), 2000 ether);

        // Approve the DPKSwaper contract to spend tokens on behalf of the test contract
        tokenIn.approve(address(dpkSwaper), 5000 ether);
        tokenOut.approve(address(dpkSwaper), 5000 ether);
    }

    // function testSwapExactInputSingle() public {         // V1
    //     // Setup: Mint tokens to the contract for testing
    //     // tokenIn.mint(address(dpkSwaper), 10000 ether);
    //     // tokenOut.mint(address(dpkSwaper), 2000 ether);
    //     // tokenIn.approve(address(dpkSwaper), 5000 ether);


    //     // Act: Call the function
    //     uint256 amountOut = dpkSwaper.swapExactInputSingle(address(tokenIn), address(tokenOut), 5000);

    //     // Assert: Check that the correct amount was transferred out
    //     assertEq(tokenIn.balanceOf(address(dpkSwaper)), 5000, "Incorrect amount of tokenIn remaining");
    //     assertGt(tokenOut.balanceOf(address(dpkSwaper)), 1500, "Incorrect amount of tokenOut received");
    // }

    // function testSWapExactInputSingle() public {         // V2
    //     // Act: Call the function
    //     try dpkSwaper.swapExactInputSingle(address(tokenIn), address(tokenOut), 5000) {
    //         // On success, check the balances
    //         assertEq(tokenIn.balanceOf(address(dpkSwaper)), 2500, "Incorrect amount of tokenIn remaining");
    //         assertGt(tokenOut.balanceOf(address(dpkSwaper)), 750, "Incorrect amount of tokenOut received");
    //     } catch Error(string memory reason) {
    //         // Handle the revert reason
    //         console.log(reason); // Assuming console.log is available in your environment
    //     }
    // }    

    function testSwapExactInputSingle() public {            // V3
        // Define parameters for the swap
        address tokenInAddr = address(tokenIn);
        address tokenOutAddr = address(tokenOut);
        uint256 amountIn = 5000 ether; // Input amount
        uint256 amountOutMinimum = 1500 ether; // Minimum output amount
        uint256 deadline = block.timestamp + 15 minutes; // Set a future deadline
        uint256 sqrtPriceLimitX96 = 0; // No price limit

        // Act: Call the function with the defined parameters
        uint256 amountOut = dpkSwaper.swapExactInputSingle(
            tokenInAddr,
            tokenOutAddr,
            amountIn
        );

        // Assert: Verify the amounts transferred
        assertEq(tokenIn.balanceOf(address(dpkSwaper)), amountIn - 5000, "Incorrect amount of tokenIn remaining");
        assertGt(tokenOut.balanceOf(address(dpkSwaper)), 1500, "Incorrect amount of tokenOut received");
    }

    // function testSwapExactOutputSingle() public {            // V1
    //     // Setup: Ensure enough tokens are minted and approved
    //     // tokenIn.mint(address(dpkSwaper), 10000 ether);
    //     // tokenOut.mint(address(dpkSwaper), 2000 ether);
    //     // tokenIn.approve(address(dpkSwaper), 5000 ether);

    //     // Define expected parameters
    //     address tokenInAddr = address(tokenIn);
    //     address tokenOutAddr = address(tokenOut);
    //     uint256 amountOutDesired = 1000 ether; // Desired output amount
    //     uint256 amountInMax = 5000 ether; // Maximum input amount
    
    //     // Act: Call the function
    //     uint256 amountIn = dpkSwaper.swapExactOutputSingle(tokenInAddr, tokenOutAddr, amountOutDesired, amountInMax);
    
    //     // Assert: Verify the amounts transferred
    //     assertEq(tokenIn.balanceOf(address(dpkSwaper)), amountInMax - amountIn, "Incorrect amount of tokenIn spent");
    //     assertEq(tokenOut.balanceOf(address(dpkSwaper)), amountOutDesired, "Incorrect amount of tokenOut received");
    // }    

    function testSwapExactOutputSingle() public {           // V2
        // Define parameters for the swap
        address tokenInAddr = address(tokenIn);
        address tokenOutAddr = address(tokenOut);
        uint256 amountOutDesired = 1000 ether; // Desired output amount
        uint256 amountInMax = 5000 ether; // Maximum input amount
        uint256 deadline = block.timestamp + 15 minutes; // Set a future deadline
        uint256 sqrtPriceLimitX96 = 0; // No price limit

        // Act: Call the function with the defined parameters
        uint256 amountIn = dpkSwaper.swapExactOutputSingle(
            tokenInAddr,
            tokenOutAddr,
            amountOutDesired,
            amountInMax
        );

        // Assert: Verify the amounts transferred
        assertEq(tokenIn.balanceOf(address(dpkSwaper)), amountInMax - amountIn, "Incorrect amount of tokenIn spent");
        assertEq(tokenOut.balanceOf(address(dpkSwaper)), amountOutDesired, "Incorrect amount of tokenOut received");
    }
    
}
