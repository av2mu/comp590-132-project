# COMP 590-132 Project


## Project Structure

```
.
├── contracts/          # Solidity contracts with Scribble instrumentation
└── package.json            # Node.js dependenciess
```

## Prerequisites

- Docker
- Node.js and npm


## Setup

Install Node.js dependencies:
```bash
npm install
```


## Running Analysis with Mythril Docker Container

1. Pull the latest Mythril Docker image:
```bash
docker pull mythril/myth
```

2. Run Mythril analysis on a contract:
```bash
docker run -v $(pwd):/tmp mythril/myth analyze /tmp/analysis/contracts/SimpleDAO.sol
```

Replace `SimpleDAO.sol` with the contract you want to analyze.

## Available Contracts

- `dao-congress.sol`: Ethereum Foundation Open Source Example DAO
- `dao-association.sol`: Ethereum Foundation Open Source Example DAO
- `SimpleDAO.sol`: A simple DAO implementation written by us with token-weighted voting
- `FlawedDAO.sol`: A DAO implementation with all detected vulnerabilities
- `SingleVoteFlawDAO.sol`: DAO with single vote vulnerability
- `QuorumFlawDAO.sol`: DAO with quorum-related vulnerabilities
- `AuthorizationFlawDAO.sol`: DAO with authorization-related vulnerabilities
- `DAOProperties.spec`: Specification file to state DAO properties

## Analysis Options

You can run the Mythril analysis with various options if you are running into issues:

```bash
# Run with specific solc version
docker run -v $(pwd):/tmp mythril/myth analyze /tmp/analysis/contracts/dao-congress.sol --solv 0.8.29

# Edit depth of analysis
docker run -v $(pwd):/tmp mythril/myth analyze /tmp/analysis/contracts/dao-congress.sol --max-depth 128

```

## Additional Resources

- [Mythril Documentation](https://mythril-classic.readthedocs.io/en/master/)
- [Scribble Documentation](https://docs.scribble.codes/)
- [Solidity Documentation](https://docs.soliditylang.org/) 