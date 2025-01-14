// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/console.sol";

contract VotingSystem {
    struct Proposal {
        uint256 id;
        string description;
        uint256 voteCount;
        address proposer;
    }

    Proposal[] public proposals;
    mapping(address => mapping(uint256 => bool)) public hasVoted;

    event ProposalCreated(uint256 id, string description, address proposer);
    event VoteCast(uint256 id, address voter);

    modifier validProposal(uint256 proposalId) {
        require(proposalId < proposals.length, "Proposal does not exist");
        _;
    }

    function createProposal(string memory description) external {
        uint256 id = proposals.length;
        proposals.push(Proposal(id, description, 0, msg.sender));
        emit ProposalCreated(id, description, msg.sender);
        console.log("Proposal created by", msg.sender);
    }

    function vote(uint256 proposalId) external validProposal(proposalId) {
        require(!hasVoted[msg.sender][proposalId], "Already voted");
        proposals[proposalId].voteCount++;
        hasVoted[msg.sender][proposalId] = true;
        emit VoteCast(proposalId, msg.sender);
        console.log("Vote cast by", msg.sender, "on proposal", proposalId);
    }

    function getProposals() external view returns (Proposal[] memory) {
        return proposals;
    }
}
