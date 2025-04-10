# SimpleDAO Analysis

This project provides a comprehensive analysis of the SimpleDAO smart contract using Scribble for formal verification and Diligence for fuzzing.

## Project Structure

```
analysis/
├── contracts/           # Smart contract source files
│   └── SimpleDAO.sol    # The SimpleDAO contract with Scribble annotations
├── config/              # Configuration files
│   ├── scribble.json    # Scribble configuration
│   └── fuzz.yml         # Diligence fuzzing configuration
├── test/                # Test files
│   └── SimpleDAO.test.js # Hardhat tests for SimpleDAO
├── scripts/             # Utility scripts
│   └── run_analysis.js  # Script to run the complete analysis
├── hardhat.config.js    # Hardhat configuration
└── package.json         # Project dependencies
```

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

### Installation

```bash
# Clone the repository
git clone <repository-url>
cd analysis

# Install dependencies
npm install
```

### Running the Analysis

```bash
# Run the complete analysis
npm run analyze

# Or run individual steps
npm run instrument  # Run Scribble instrumentation
npm test           # Run Hardhat tests
npm run fuzz       # Run Diligence fuzzing
```

## License

This project is licensed under the MIT License - see the LICENSE file for details. 