# SimpleDAO Analysis

This project provides a comprehensive analysis of the SimpleDAO smart contract using Scribble for formal verification and Mythril for security analysis.

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
└── package.json     # Project dependencies and scripts
```

Key files:
- `contracts/SimpleDAO.sol`: Main DAO contract implementation
- `scripts/deploy.ts`: Contract deployment script
- `scripts/run_analysis.js`: Analysis orchestration script
- `scripts/run_mythril.py`: Mythril security analysis script
- `hardhat.config.ts`: Hardhat and network configuration

## Available Scripts

- `npm run compile` - Compile the contracts
- `npm run deploy` - Deploy contracts to local network
- `npm run instrument` - Instrument contracts with Scribble
- `npm run analyze` - Run full analysis suite
- `npm test` - Run the test suite
- `python3 scripts/run_mythril.py` - Run Mythril security analysis

## Features

- **Scribble Annotations**: The SimpleDAO contract is annotated with Scribble specifications to enable formal verification.
- **Security Analysis**: Mythril is used to perform security analysis on the instrumented contracts.
- **Comprehensive Testing**: Hardhat tests cover all contract functionality.
- **Automated Analysis**: Scripts to run the complete analysis pipeline.

## Scribble Annotations

The SimpleDAO contract includes Scribble annotations for:

- Access control (admin-only functions)
- Token holder validation
- Voting period constraints
- Vote recording and weighting
- Proposal finalization conditions

## Security Analysis

Mythril performs security analysis on the following aspects:

- Reentrancy vulnerabilities
- Integer overflow/underflow
- Access control issues
- Unchecked external calls
- State consistency
- Gas optimization issues
- Potential race conditions

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
python3 scripts/run_mythril.py  # Run Mythril security analysis
```

### Mythril Analysis

The Mythril analysis script (`scripts/run_mythril.py`) will:

1. Look for instrumented contracts in the `instrumented/` directory
2. Run Mythril's security analysis on each contract
3. Report any potential vulnerabilities or issues found
4. Provide detailed information about each finding

The analysis includes:
- Transaction depth: 3
- Execution timeout: 60 seconds
- Solver timeout: 60 seconds
- State space pruning factor: 0.8
