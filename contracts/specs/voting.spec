/// @title Voting Properties
/// @notice Properties related to voting mechanisms in DAOs

/// @property {:msg "Single vote per address"} 
///     proposals[_proposalId].hasVoted[msg.sender] == true;

/// @property {:msg "Vote weight is correct"} 
///     (_support ==> proposals[_proposalId].yesVotes == old(proposals[_proposalId].yesVotes) + voteWeight) &&
///     (!_support ==> proposals[_proposalId].noVotes == old(proposals[_proposalId].noVotes) + voteWeight);

/// @property {:msg "Voting period is valid"} 
///     block.timestamp >= proposals[_proposalId].startTime && 
///     block.timestamp <= proposals[_proposalId].endTime; 