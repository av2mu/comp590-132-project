#!/usr/bin/env python3
import os
import subprocess
import sys
from pathlib import Path

def run_mythril_analysis(contract_path):
    """
    Run Mythril analysis on a given contract file.
    
    Args:
        contract_path (str): Path to the contract file to analyze
    """
    try:
        # Run mythril analyze command
        cmd = [
            "myth",
            "analyze",
            contract_path,
            "--execution-timeout", "60",  # 60 second timeout
            "--max-depth", "3",  # Transaction depth
            "--solver-timeout", "60000",  # 60 second solver timeout
            "--pruning-factor", "0.8"  # Pruning factor for state space
        ]
        
        print(f"Running Mythril analysis on {contract_path}...")
        result = subprocess.run(cmd, capture_output=True, text=True)
        
        if result.returncode == 0:
            print("Analysis completed successfully!")
            print(result.stdout)
        else:
            print("Analysis found potential issues:")
            print(result.stdout)
            print("Errors/Warnings:")
            print(result.stderr)
            
    except Exception as e:
        print(f"Error running Mythril analysis: {str(e)}")
        sys.exit(1)

def main():
    # Get the instrumented contracts directory
    instrumented_dir = Path("instrumented")
    contracts_dir = Path("contracts")
    
    if not instrumented_dir.exists():
        print("Warning: instrumented directory not found. Checking contracts directory...")
    
    # Find all .sol files in both directories
    sol_files = list(instrumented_dir.glob("**/*.sol")) + list(contracts_dir.glob("**/*.sol.instrumented"))
    
    if not sol_files:
        print("No instrumented .sol files found in either the instrumented or contracts directory.")
        sys.exit(1)
    
    # Run analysis on each contract
    for contract in sol_files:
        print(f"\nAnalyzing {contract}...")
        run_mythril_analysis(str(contract))

if __name__ == "__main__":
    main() 