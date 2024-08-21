// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script} from "../lib/forge-std/src/Script.sol";
import {console} from "../lib/forge-std/src/console.sol";
import {DPKSwaper} from "../src/DPKSwaper.sol";

contract DeployDPKSwaper is Script {
    uint256 deployerPrivateKey;
    address deployerAccount;

    address public constant routerAddress = 0xE592427A0AEce92De3Edee1F18E0157C05861564;

    DPKSwaper public dpkSwaper;

    function setUp() public {
        deployerPrivateKey = vm.envUint("DEV_PRIVATE_KEY");
        deployerAccount = vm.addr(deployerPrivateKey);
        vm.startBroadcast(deployerPrivateKey);
    }

     function run() external returns (DPKSwaper) {
        dpkSwaper = new DPKSwaper(routerAddress);
        console.log("DPKSwaper deployed at:", address(dpkSwaper));
        // Your deployment code...
        return dpkSwaper;
    }
}