const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

// Configuration
const CONFIG = {
  scribbleConfig: path.join(__dirname, '../config/scribble.json'),
  contractPath: path.join(__dirname, '../contracts/GovernorBravoDelegate.sol'),
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

// Run Scribble instrumentation
function runScribble() {
  console.log('Running Scribble instrumentation...');
  try {
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
  console.log('Starting SimpleDAO analysis...');
  
  // Ensure all directories exist
  ensureDirectories();
  
  // Run Scribble instrumentation
  runScribble();
  
  // Run Hardhat tests
  runTests();
  
  console.log('SimpleDAO analysis completed successfully.');
}

main().catch(error => {
  console.error('Error in main:', error);
  process.exit(1);
}); 