const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

// Configuration
const CONFIG = {
  scribbleConfig: path.join(__dirname, '../config/scribble.json'),
  fuzzConfig: path.join(__dirname, '../config/fuzz.yml'),
  contractPath: path.join(__dirname, '../contracts/SimpleDAO.sol'),
  instrumentedPath: path.join(__dirname, '../instrumented'),
  testPath: path.join(__dirname, '../test/SimpleDAO.test.js'),
};

// Ensure directories exist
function ensureDirectories() {
  const dirs = [
    path.dirname(CONFIG.scribbleConfig),
    path.dirname(CONFIG.fuzzConfig),
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
    execSync(`npx scribble ${CONFIG.contractPath} --output-dir ${CONFIG.instrumentedPath}`, { stdio: 'inherit' });
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

// Run Diligence fuzzing
function runFuzzing() {
  console.log('Running Diligence fuzzing...');
  try {
    execSync(`npx diligence fuzz ${CONFIG.fuzzConfig}`, { stdio: 'inherit' });
    console.log('Diligence fuzzing completed successfully.');
  } catch (error) {
    console.error('Error running Diligence fuzzing:', error.message);
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
  
  // Run Diligence fuzzing
  runFuzzing();
  
  console.log('SimpleDAO analysis completed successfully.');
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  }); 