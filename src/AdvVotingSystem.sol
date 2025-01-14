// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract AdvVotingSystem {
    struct Proposal {
        string description;
        uint256 voteCount;
        bool finalized;
    }

    mapping(uint256 => Proposal) public proposals;
    mapping(address => mapping(uint256 => bool)) public hasVoted;
    uint256 public proposalCount;

    event ProposalCreated(uint256 proposalId, string description);
    event VoteCasted(uint256 proposalId, address voter);
    event ProposalFinalized(uint256 proposalId);

    function createProposal(string memory description) public {
        proposals[proposalCount] = Proposal(description, 0, false);
        emit ProposalCreated(proposalCount, description);
        proposalCount++;
    }

    function vote(uint256 proposalId) public {
        require(!proposals[proposalId].finalized, "Proposal is finalized");
        require(!hasVoted[msg.sender][proposalId], "Already voted");

        proposals[proposalId].voteCount++;
        hasVoted[msg.sender][proposalId] = true;

        emit VoteCasted(proposalId, msg.sender);
    }

    function finalizeProposal(uint256 proposalId) public {
        require(!proposals[proposalId].finalized, "Already finalized");

        proposals[proposalId].finalized = true;
        emit ProposalFinalized(proposalId);
    }
}
