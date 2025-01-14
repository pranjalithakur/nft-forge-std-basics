// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Script, console} from "forge-std/Script.sol";
import {VotingSystem} from "../src/VotingSystem.sol";

contract DeployVotingSystem is Script {
    function run() external {
        vm.startBroadcast();
        VotingSystem votingSystem = new VotingSystem();
        console.log("VotingSystem deployed at:", address(votingSystem));
        vm.stopBroadcast();
    }
}
