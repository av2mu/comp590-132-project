# SimpleDAO Analysis

This project provides a comprehensive analysis of the SimpleDAO smart contract using Scribble for formal verification and Diligence for fuzzing.

## Project Structure

```
├── contracts/          # Smart contract source files
├── scripts/           # Deployment and analysis scripts
├── test/             # Test files
├── instrumented/     # Scribble-instrumented contracts
├── config/           # Configuration files for tools
├── artifacts/        # Compiled contract artifacts
├── cache/           # Hardhat cache
├── typechain-types/ # TypeScript typings for contracts
├── hardhat.config.ts # Hardhat configuration
├── tsconfig.json    # TypeScript configuration
├── package.json     # Project dependencies and scripts
└── .fuzz.yml       # Diligence fuzzing configuration
```

Key files:
- `contracts/SimpleDAO.sol`: Main DAO contract implementation
- `scripts/deploy.ts`: Contract deployment script
- `scripts/run_analysis.js`: Analysis orchestration script
- `.fuzz.yml`: Configuration for Diligence fuzzing
- `hardhat.config.ts`: Hardhat and network configuration

## Available Scripts

- `npm run compile` - Compile the contracts
- `npm run deploy` - Deploy contracts to local network
- `npm run instrument` - Instrument contracts with Scribble
- `npm run fuzz` - Run Diligence fuzzing tests
- `npm run analyze` - Run full analysis suite
- `npm test` - Run the test suite

## Features

- **Scribble Annotations**: The SimpleDAO contract is annotated with Scribble specifications to enable formal verification.
- **Comprehensive Testing**: Hardhat tests cover all contract functionality.
- **Fuzzing**: Diligence fuzzing is configured to test various properties of the contract.
- **Automated Analysis**: A script to run the complete analysis pipeline.

## Scribble Annotations

The SimpleDAO contract includes Scribble annotations for:

- Access control (admin-only functions)
- Token holder validation
- Voting period constraints
- Vote recording and weighting
- Proposal finalization conditions

## Fuzzing Properties

The fuzzing configuration tests the following properties:

- Admin-only functions
- Valid voting periods
- Correct start and end times
- Token holder voting rights
- Voting time window constraints
- No double voting
- Vote recording
- Finalization conditions
- Token balance management

## Getting Started

### Prerequisites

- Node.js (v14 or later)
- npm or yarn
- Python 3.7 or later
- pip3

### Installation

```bash
# Clone the repository
git clone https://github.com/av2mu/comp590-132-project.git
(make a venv now at this point if you want)
# Install Node.js dependencies
npm install

# Install Python dependencies
pip3 install -r requirements.txt
```

### Running the Analysis

```bash
# Run the complete analysis
npm run analyze

# Or run individual steps
npm run instrument  # Run Scribble instrumentation
npm test           # Run Hardhat tests
npm run fuzz       # Run Diligence fuzzing
