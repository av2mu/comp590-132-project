// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

/// @title Authorization Specification
/// @notice Abstract Scribble specification for authorization properties
/// @dev Defines abstract authorization properties that can be used across contracts
abstract contract AuthorizationSpec {
    /// @notice Abstract function to check if an address is an eligible voter
    /// @dev Must be implemented by contracts using this specification
    /// @param voter The address to check
    /// @return bool True if the address is an eligible voter
    function isEligibleVoter(address voter) internal view virtual returns (bool);

    /// @notice Authorization property for voting
    /// @dev This property ensures that only eligible voters can vote
    /// #require isEligibleVoter(msg.sender);
    modifier onlyEligibleVoter() {
        require(isEligibleVoter(msg.sender), "Not an eligible voter");
        _;
    }

    /// @notice Global authorization invariant
    /// @dev This invariant must hold true at all times
    /// #invariant forall (address voter) isEligibleVoter(voter) ==> voter != address(0);
} 