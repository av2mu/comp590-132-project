/// @title Quorum Properties
/// @notice Properties related to quorum requirements in DAOs

/// @property {:msg "Quorum is met before execution"} 
///     (proposals[_proposalId].yesVotes + proposals[_proposalId].noVotes) >= 
///     (totalTokens * QUORUM_THRESHOLD) / 100 || 
///     proposals[_proposalId].numberOfVotes >= minimumQuorum; 