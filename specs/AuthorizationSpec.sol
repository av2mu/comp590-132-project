// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;
import "../contracts/SimpleDAO.sol";

/// @title AuthorizationSpec ― Only token holders may vote
contract AuthorizationSpec is SimpleDAO {
    /// #if_succeeds {:msg "Authorization"} tokenBalances[msg.sender] > 0;
    function vote(uint256 _proposalId, bool _support) public override {
        super.vote(_proposalId, _support);
    }
} 