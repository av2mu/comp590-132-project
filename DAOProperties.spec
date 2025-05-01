/// @title DAO Properties Specification
/// @notice Abstract properties that should hold for any DAO implementation

// Authorization Properties
/// @property {:msg "Only token holders can vote"} 
///     tokenBalances[msg.sender] > 0 || isMember[msg.sender] == true;

// Voting Properties
/// @property {:msg "Single vote per address"} 
///     proposals[_proposalId].hasVoted[msg.sender] == true;

// Quorum Properties
/// @property {:msg "Quorum is met before execution"} 
///     (proposals[_proposalId].yesVotes + proposals[_proposalId].noVotes) >= 
///     (totalTokens * QUORUM_THRESHOLD) / 100 || 
///     proposals[_proposalId].numberOfVotes >= minimumQuorum;

