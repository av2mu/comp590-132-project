// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "./AbstractProposalFinalitySpec.sol";
import "../contracts/ProposalFinalityFlaw.sol";

/// @title ProposalFinalityFlawSpecs
/// @notice Concrete implementation of proposal finality specs for ProposalFinalityFlaw
contract ProposalFinalityFlawSpecs is 
    ProposalFinalityFlaw,
    AbstractProposalFinalitySpec {

    // Implementation of AbstractProposalFinalitySpec
    function isExecuted(uint256 proposalId) internal override returns (bool) {
        return proposals[proposalId].executed;
    }

    function getYesVotes(uint256 proposalId) internal override returns (uint256) {
        return proposals[proposalId].yesVotes;
    }

    function getNoVotes(uint256 proposalId) internal override returns (uint256) {
        return proposals[proposalId].noVotes;
    }

    // Override ProposalFinalityFlaw's vote function to use our specs
    function vote(uint256 _proposalId, bool _support) public override {
        // Use our proposal finality spec
        verifyProposalFinality(_proposalId);

        // Rest of ProposalFinalityFlaw's implementation
        Proposal storage proposal = proposals[_proposalId];
        require(!proposal.hasVoted[msg.sender], "Already voted");
        proposal.hasVoted[msg.sender] = true;

        if (_support) {
            proposal.yesVotes += 1;
        } else {
            proposal.noVotes += 1;
        }
        emit VoteCast(_proposalId, msg.sender, _support);
    }
} 