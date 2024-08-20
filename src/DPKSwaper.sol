// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ISwapRouter} from "../lib/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import {ReentrancyGuard} from "../lib/openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol";

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function approve(address spender, uint256 amount) external returns (bool);
}

// @title DPK Swapper Contract
/// @author Dylan Katsch
/// @notice Allows swapping tokens using Uniswap V3's periphery contracts.
/// @dev All function calls are subject to a reentrancy guard.
contract DPKSwaper is ReentrancyGuard {

    /// @notice Emitted when a swap input operation occurs.
    /// @param tokenIn The address of the input token.
    /// @param tokenOut The address of the output token.
    /// @param amountIn The amount of input tokens sent.
    /// @param amountOut The amount of output tokens received.
    event SwapInput(
        address indexed tokenIn,
        address indexed tokenOut,
        uint256 amountIn,
        uint256 amountOut
    );
    
    /// @notice Emitted when a swap output operation occurs.
    /// @param tokenIn The address of the input token.
    /// @param tokenOut The address of the output token.
    /// @param amountIn The amount of input tokens sent.
    /// @param amountOut The amount of output tokens received.
    event SwapOutput(
        address indexed tokenIn,
        address indexed tokenOut,
        uint256 amountIn,
        uint256 amountOut
    );

    /// @notice The address of the Uniswap V3 router contract.
    // address public constant routerAddress = 0xE592427A0AEce92De3Edee1F18E0157C05861564; 

    /// @notice The instance of the ISwapRouter interface connected to the router address.
    ISwapRouter public immutable swapRouter;

    /// @notice The fee tier for the pool being swapped on.
    uint24 public constant poolFee = 3000;

    constructor(address _swapRouter) {
        require(_swapRouter != address(0), "Zero address not allowed");
        swapRouter = ISwapRouter(_swapRouter);
    }

    /// @notice Swaps an exact input amount of one token for another token.
    /// @dev Calls the Uniswap V3 router's exactInputSingle function.
    /// @param tokenIn The address of the token being sent.
    /// @param tokenOut The address of the token being received.
    /// @param amountIn The exact amount of tokens to send.
    /// @return amountOut The amount of tokens received.
    function swapExactInputSingle(
        address tokenIn, 
        address tokenOut, 
        uint256 amountIn
    ) 
        external 
        nonReentrant
        returns (uint256 amountOut) 
    {
        IERC20(tokenIn).approve(address(swapRouter), amountIn);

        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter
            .ExactInputSingleParams({
                tokenIn: tokenIn,
                tokenOut: tokenOut,
                fee: poolFee, 
                recipient: address(this),
                deadline: block.timestamp,
                amountIn: amountIn,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0 
            });

        amountOut = swapRouter.exactInputSingle(params);

        emit SwapInput(tokenIn, tokenOut, amountIn, amountOut);
    }

    /// @notice Swaps until an exact output amount of one token is received for another token.
    /// @dev Calls the Uniswap V3 router's exactOutputSingle function.
    /// @param tokenIn The address of the token being sent.
    /// @param tokenOut The address of the token being received.
    /// @param amountOut The exact amount of tokens to receive.
    /// @param amountInMaximum The maximum amount of tokens to send.
    /// @return amountIn The actual amount of tokens sent.
    function swapExactOutputSingle(
        address tokenIn, 
        address tokenOut, 
        uint256 amountOut, 
        uint256 amountInMaximum
    ) 
        external 
        nonReentrant
        returns (uint256 amountIn) 
    {
        IERC20(tokenIn).approve(address(swapRouter), amountInMaximum);

        ISwapRouter.ExactOutputSingleParams memory params = ISwapRouter.ExactOutputSingleParams({
                tokenIn: tokenIn,
                tokenOut: tokenOut,
                fee: poolFee, 
                recipient: address(this),
                deadline: block.timestamp,
                amountOut: amountOut,
                amountInMaximum: amountInMaximum,
                sqrtPriceLimitX96: 0 
            });

        amountIn = swapRouter.exactOutputSingle(params);

        emit SwapOutput(tokenIn, tokenOut, amountIn, amountOut);

        if (amountIn < amountInMaximum) {
            IERC20(tokenIn).approve(address(swapRouter), 0);
            IERC20(tokenIn).transfer(address(this), amountInMaximum - amountIn);
        }
    }
}