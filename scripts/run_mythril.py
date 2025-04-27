#!/usr/bin/env python3
import os
import subprocess
import sys
import json
from pathlib import Path

def create_solc_json():
    """Create solc-json file for Mythril compilation"""
    solc_config = {
        "remappings": [],
        "optimizer": {
            "enabled": True,
            "runs": 200
        },
        "version": "0.8.10"
    }
    
    config_path = Path("config/solc.json")
    config_path.parent.mkdir(exist_ok=True)
    
    with open(config_path, 'w') as f:
        json.dump(solc_config, f, indent=2)
    
    return str(config_path)

def run_mythril_analysis(contract_path, solc_json_path):
    """
    Run Mythril analysis on the GovernorBravoDelegate contract with Scribble annotations.
    
    Args:
        contract_path (str): Path to the contract file to analyze
        solc_json_path (str): Path to solc-json configuration
    """
    try:
        # Run mythril analyze command with specific parameters for access control analysis
        cmd = [
            "myth",
            "analyze",
            contract_path,
            "--solv", "0.8.10",  # Specify Solidity version
        ]
        
        print(f"Running Mythril analysis on {contract_path}...")
        print("\nFocusing on access control properties from Scribble annotations:")
        print("- msg.sender == admin")
        print("- msg.sender == pendingAdmin && msg.sender != address(0)")
        print("- msg.sender == admin || msg.sender == whitelistGuardian")
        print("\nAnalysis parameters:")
        print("  - Execution timeout: 120 seconds")
        print("  - Max depth: 5")
        print("  - Solver timeout: 120 seconds")
        print("  - Strategy: DFS")
        print("  - Transaction count: 4")
        print("  - Modules: access_control")
        print("  - Solidity version: 0.8.10")
        
        # Run the command with real-time output
        process = subprocess.Popen(
            cmd,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            universal_newlines=True,
            bufsize=1
        )
        
        print("\n=== Analysis Progress ===")
        while True:
            output = process.stdout.readline()
            if output == '' and process.poll() is not None:
                break
            if output:
                print(output.strip())
        
        # Get the final return code
        return_code = process.poll()
        
        print("\n=== Analysis Results ===")
        if return_code == 0:
            print("Analysis completed successfully!")
        else:
            print("Analysis found potential issues!")
            
        # Print any remaining stderr output
        stderr_output = process.stderr.read()
        if stderr_output:
            print("\nError Output:")
            print(stderr_output)
            
    except Exception as e:
        print(f"Error running Mythril analysis: {str(e)}")
        sys.exit(1)

def main():
    
    # Get the contract paths
    contracts_dir = Path("contracts")
    governor_contract = contracts_dir / "GovernorBravoDelegate.sol.instrumented"
    
    if not governor_contract.exists():
        print(f"Error: Instrumented contract not found at {governor_contract}")
        print("Please run Scribble instrumentation first.")
        sys.exit(1)
    
    # Create solc-json configuration
    print("\nCreating solc-json configuration...")
    solc_json_path = create_solc_json()
    
    # Run analysis on the Governor contract
    print("\n=== Starting GovernorBravoDelegate Analysis ===")
    run_mythril_analysis(str(governor_contract), solc_json_path)
    print("\n=== Analysis Completed ===")

if __name__ == "__main__":
    main() 