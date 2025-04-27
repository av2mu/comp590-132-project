// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;
import "../contracts/SimpleDAO.sol";

/// @title ProposalFinalitySpec ― Once a proposal is finalized, its votes cannot change
contract ProposalFinalitySpec is SimpleDAO {
    /// #invariant {:msg "Proposal finality"}
    ///     forall (uint256 p in 0 .. proposalCount)
    ///         proposals[p].executed ==> 
    ///             (proposals[p].yesVotes == old(proposals[p].yesVotes) && 
    ///              proposals[p].noVotes == old(proposals[p].noVotes));
} 