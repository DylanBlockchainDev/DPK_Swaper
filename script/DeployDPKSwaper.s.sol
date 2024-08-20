// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script} from "../lib/forge-std/src/Script.sol";
import {console} from "../lib/forge-std/src/console.sol";
import {DPKSwaper} from "../src/DPKSwaper.sol";

contract DeployDPKSwaper is Script {
    /// @notice Deploys the DPKSwaper contract.
    function run() public {
        // Start broadcasting transactions with a derived private key
        vm.startBroadcast(vm.deriveKey(vm.envString("MNEMONIC"), 0)); // private key from enviroment variabl.

        // Deploy the DPKSwaper contract with this ISwapRouter address '0xE592427A0AEce92De3Edee1F18E0157C05861564'
        DPKSwaper dpkSwaper = new DPKSwaper(address(0xE592427A0AEce92De3Edee1F18E0157C05861564));

        // Stop broadcasting transactions
        vm.stopBroadcast();

        // Print the address of the deployed contract
        console.log("DPKSwaper deployed at:", address(dpkSwaper)); // sotre contract address to enviroment variable!!!
    }
}