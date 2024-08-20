// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ISwapRouter} from "../../lib/v3-periphery/contracts/interfaces/ISwapRouter.sol";

contract MockISwapRouter is ISwapRouter {
    function exactInputSingle(ISwapRouter.ExactInputSingleParams calldata params) external payable override returns (uint256 amountOut) {
        // Implement logic to simulate the behavior of exactInputSingle
    }

    function exactOutputSingle(ISwapRouter.ExactOutputSingleParams calldata params) external payable override returns (uint256 amountIn) {
        // Implement logic for exactOutputSingle
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

    function getAddress() public view returns(address) {
        return(address(this));
    }
}