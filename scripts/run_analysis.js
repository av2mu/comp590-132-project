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
  console.log('Created Scribble configuration file with properties:');
  config.properties.forEach(prop => console.log(`  - ${prop}`));
}

// Run Scribble instrumentation
function runScribble() {
  console.log('\n=== Running Scribble Instrumentation ===');
  
  try {
    // Instrument the interfaces file
    console.log('\nInstrumenting GovernorBravoInterfaces.sol...');
    execSync(`npx scribble --output-mode files --utils-output-path ${CONFIG.instrumentedPath} ${CONFIG.interfacesPath}`, { stdio: 'inherit' });
    
    // Instrument the main contract
    console.log('\nInstrumenting GovernorBravoDelegate.sol...');
    execSync(`npx scribble --output-mode files --utils-output-path ${CONFIG.instrumentedPath} ${CONFIG.contractPath}`, { stdio: 'inherit' });

    // Verify the instrumented contract
    console.log('\nVerifying instrumented contract...');
    const verifyOutput = execSync(`npx scribble --verify ${CONFIG.contractPath}`, { stdio: 'pipe' });
    console.log(verifyOutput.toString());
    
    console.log('\nScribble instrumentation completed successfully.');
  } catch (error) {
    console.error('Error running Scribble instrumentation:', error.message);
    process.exit(1);
  }
}

// Run Hardhat tests
function runTests() {
  console.log('\n=== Running Hardhat Tests ===');
  try {
    // First compile the instrumented contract
    console.log('Compiling instrumented contract...');
    execSync('npx hardhat compile', { stdio: 'inherit' });

    // Then run the tests
    console.log('\nRunning tests...');
    execSync('npx hardhat test', { stdio: 'inherit' });
    
    console.log('\nHardhat tests completed successfully.');
  } catch (error) {
    console.error('Error running Hardhat tests:', error.message);
    process.exit(1);
  }
}

// Main function
async function main() {
  console.log('=== Starting GovernorBravoDelegate Analysis ===');
  
  // Ensure all directories exist
  console.log('\nSetting up directories...');
  ensureDirectories();
  
  // Create Scribble config
  console.log('\nConfiguring Scribble...');
  createScribbleConfig();
  
  // Run Scribble instrumentation
  runScribble();
  
  console.log('\n=== GovernorBravoDelegate Analysis Completed ===');
}

main().catch(error => {
  console.error('Error in main:', error);
  process.exit(1);
}); 