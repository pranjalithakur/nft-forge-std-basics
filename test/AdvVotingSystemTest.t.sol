// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import {AdvVotingSystem} from "../src/AdvVotingSystem.sol";

contract VotingSystemTest is Test {
    using stdStorage for StdStorage;

    AdvVotingSystem votingSystem;

    function setUp() public {
        votingSystem = new AdvVotingSystem();
    }

    // Test creating a proposal
    function testCreateProposal() public {
        votingSystem.createProposal("Test Proposal");

        uint256 slot = stdstore.target(address(votingSystem)).sig("proposalCount()").find();

        uint256 proposalCount = uint256(vm.load(address(votingSystem), bytes32(slot)));
        assertEq(proposalCount, 1, "Proposal count mismatch");
    }

    // Test voting on a proposal
    function testVote() public {
        votingSystem.createProposal("Test Proposal");

        votingSystem.vote(0);

        uint256 slot = stdstore.target(address(votingSystem)).sig(votingSystem.proposals.selector).with_key(uint256(0))
            .depth(1) // Proposal ID
                // Access `voteCount` field of struct
            .find();

        uint256 voteCount = uint256(vm.load(address(votingSystem), bytes32(slot)));
        assertEq(voteCount, 1, "Vote count mismatch");
    }

    // Test finalizing a proposal
    function testFinalizeProposal() public {
        votingSystem.createProposal("Test Proposal");

        votingSystem.finalizeProposal(0);

        uint256 slot = stdstore.target(address(votingSystem)).sig(votingSystem.proposals.selector).with_key(uint256(0))
            .depth(2) // Proposal ID
                // Access `finalized` field of struct
            .find();

        bool finalized = vm.load(address(votingSystem), bytes32(slot)) == bytes32(uint256(1));
        assertTrue(finalized, "Proposal not finalized");
    }

    // Test reverting on double voting
    function testRevertOnDoubleVote() public {
        votingSystem.createProposal("Test Proposal");

        votingSystem.vote(0);
        vm.expectRevert("Already voted");
        votingSystem.vote(0);
    }

    // Test hoaxing and voting
    function testHoaxVoting() public {
        votingSystem.createProposal("Test Proposal");

        hoax(address(1337));
        votingSystem.vote(0);

        uint256 slot = stdstore.target(address(votingSystem)).sig(votingSystem.hasVoted.selector).with_key(
            address(1337)
        ).with_key(uint256(0)) // Voter address
                // Proposal ID
            .find();

        bool voted = vm.load(address(votingSystem), bytes32(slot)) == bytes32(uint256(1));
        assertTrue(voted, "Vote not recorded correctly");
    }
}
