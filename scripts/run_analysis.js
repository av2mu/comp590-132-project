const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

// Configuration
const CONFIG = {
  scribbleConfig: path.join(__dirname, '../config/scribble.json'),
  contractPath: path.join(__dirname, '../contracts/GovernorBravoDelegate.sol'),
  interfacesPath: path.join(__dirname, '../contracts/GovernorBravoInterfaces.sol'),
  instrumentedPath: path.join(__dirname, '../instrumented'),
  testPath: path.join(__dirname, '../test/GovernorBravoDelegate.test.js'),
};

// Ensure directories exist
function ensureDirectories() {
  const dirs = [
    path.dirname(CONFIG.scribbleConfig),
    path.dirname(CONFIG.contractPath),
    CONFIG.instrumentedPath,
    path.dirname(CONFIG.testPath),
  ];
  
  dirs.forEach(dir => {
    if (!fs.existsSync(dir)) {
      fs.mkdirSync(dir, { recursive: true });
      console.log(`Created directory: ${dir}`);
    }
  });
}

// Create Scribble config file
function createScribbleConfig() {
  const config = {
    "properties": [
      "msg.sender == admin",
      "msg.sender == pendingAdmin && msg.sender != address(0)",
      "msg.sender == admin || msg.sender == whitelistGuardian"
    ],
    "mode": "assertion",
    "optimizer": {
      "enabled": true,
      "runs": 200
    }
  };

  fs.writeFileSync(CONFIG.scribbleConfig, JSON.stringify(config, null, 2));
  console.log('Created Scribble configuration file');
}

// Run Scribble instrumentation
function runScribble() {
  console.log('Running Scribble instrumentation...');
  try {
    // First instrument the interfaces file
    execSync(`npx scribble --output-mode files --utils-output-path ${CONFIG.instrumentedPath} ${CONFIG.interfacesPath}`, { stdio: 'inherit' });
    
    // Then instrument the main contract
    execSync(`npx scribble --output-mode files --utils-output-path ${CONFIG.instrumentedPath} ${CONFIG.contractPath}`, { stdio: 'inherit' });
    
    console.log('Scribble instrumentation completed successfully.');
  } catch (error) {
    console.error('Error running Scribble instrumentation:', error.message);
    process.exit(1);
  }
}

// Run Hardhat tests
function runTests() {
  console.log('Running Hardhat tests...');
  try {
    execSync('npx hardhat test', { stdio: 'inherit' });
    console.log('Hardhat tests completed successfully.');
  } catch (error) {
    console.error('Error running Hardhat tests:', error.message);
    process.exit(1);
  }
}

// Main function
async function main() {
  console.log('Starting GovernorBravoDelegate analysis...');
  
  // Ensure all directories exist
  ensureDirectories();
  
  // Create Scribble config
  createScribbleConfig();
  
  // Run Scribble instrumentation
  runScribble();
  
  // Run Hardhat tests
  runTests();
  
  console.log('GovernorBravoDelegate analysis completed successfully.');
}

main().catch(error => {
  console.error('Error in main:', error);
  process.exit(1);
}); 