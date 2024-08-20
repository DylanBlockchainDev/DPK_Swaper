// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ISwapRouter} from "../../lib/v3-periphery/contracts/interfaces/ISwapRouter.sol";

contract MockISwapRouter is ISwapRouter {
    function exactInputSingle(ISwapRouter.ExactInputSingleParams calldata params) external payable override returns (uint256 amountOut) {
        // Example calculation logic
        // This is a simplified version. Realistic calculations would involve fetching pool data and performing precise calculations based on the pool's state.
        // For testing purposes, this example simply returns the input amount as the output amount.
        amountOut = params.amountIn;
    }

    function exactOutputSingle(ISwapRouter.ExactOutputSingleParams calldata params) external payable override returns (uint256 amountIn) {
        // Example calculation logic
        // This is a simplified version. Realistic calculations would involve fetching pool data and performing precise calculations based on the pool's state.
        // For testing purposes, this example simply returns the input amount as the output amount.
        amountIn = params.amountOut;
    }

    function exactInput(ISwapRouter.ExactInputParams calldata params) external payable override returns (uint256) {
        return 0; // Stubbed out return value
    }

    function exactOutput(ISwapRouter.ExactOutputParams calldata params) external payable override returns (uint256) {
        return 0; // Stubbed out return value
    }

    function uniswapV3SwapCallback(int256 amount0Delta,
        int256 amount1Delta,
        bytes calldata data) external {
        // Stubbed out implementation
    }

    // function getAddress() public view returns(address) {
    //     return(address(this));
    // }
}