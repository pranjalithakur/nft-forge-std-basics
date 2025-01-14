// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Test} from "forge-std/Test.sol";
import {VotingSystem} from "../src/VotingSystem.sol";

contract VotingSystemTest is Test {
    VotingSystem votingSystem;

    function setUp() public {
        votingSystem = new VotingSystem();
    }

    function testCreateProposal() public {
        votingSystem.createProposal("Build a new feature");
        VotingSystem.Proposal[] memory proposals = votingSystem.getProposals();
        assertEq(proposals.length, 1);
        assertEq(proposals[0].description, "Build a new feature");
    }

    function testVote() public {
        votingSystem.createProposal("Improve UI");
        votingSystem.vote(0);

        VotingSystem.Proposal[] memory proposals = votingSystem.getProposals();
        assertEq(proposals[0].voteCount, 1);
    }

    function testDoubleVoteReverts() public {
        votingSystem.createProposal("Enhance UX");
        votingSystem.vote(0);

        vm.expectRevert("Already voted");
        votingSystem.vote(0);
    }
}
