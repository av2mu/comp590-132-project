// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

/// @title AbstractAuthorizationSpec
/// @notice Abstract specification for token-weighted voting authorization
/// @dev Concrete implementations must implement getVotingPower
abstract contract AbstractAuthorizationSpec {
    /// @notice Get the voting power of an address
    /// @param voter The address to check voting power for
    /// @return The voting power of the address
    function getVotingPower(address voter) internal virtual returns (uint256);

    /// @notice Verify that only addresses with voting power can vote
    /// @param voter The address attempting to vote
    /// #if_succeeds {:msg "Authorization"} getVotingPower(voter) > 0;
    function verifyAuthorization(address voter) internal {
        require(getVotingPower(voter) > 0, "Must have voting power");
    }
} 