// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SingleVoteFlawDAO
/// @notice Toy DAO where the same address can vote many times
contract SingleVoteFlawDAO {
    mapping(address => bool) public isMember;

    struct Proposal {
        uint256 yes;
        uint256 no;
        mapping(address => bool) voted;  // <-- intent: mark who has voted
    }

    mapping(uint256 => Proposal) public proposals;
    uint256 public proposalCount;

    /* ----------- helper ----------- */

    function register() external {                  // anyone may join
        isMember[msg.sender] = true;
    }

    function createProposal() external returns (uint256) {
        return proposalCount++;
    }

    /* ----------- VOTE (BUGGY) ----------- */

    /// #if_succeeds {:msg "single-vote"} proposals[id].voted[msg.sender];
    ///     // Property: after a successful call, this voter must be marked as having voted.
    ///     // (The implementation *forgets* to set it, so Mythril will reach a failure.)
    function vote(uint256 id, bool support) external {
        require(isMember[msg.sender], "not a member");
        Proposal storage p = proposals[id];

        // ✗ BUG ✗  – no check & no bookkeeping
        if (support) p.yes += 1;
        else         p.no  += 1;
    }
} 