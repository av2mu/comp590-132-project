#!/usr/bin/env python3
import os
import subprocess
import sys
from pathlib import Path

def run_mythril_analysis(contract_path):
    """
    Run Mythril analysis on the GovernorBravoDelegate contract with Scribble annotations.
    
    Args:
        contract_path (str): Path to the contract file to analyze
    """
    try:
        # Run mythril analyze command with specific parameters for access control analysis
        cmd = [
            "myth",
            "analyze",
            contract_path,
            "--execution-timeout", "120",  # 120 second timeout
            "--max-depth", "5",  # Increased transaction depth for better coverage
            "--solver-timeout", "120000",  # 120 second solver timeout
            "--pruning-factor", "0.8",  # Pruning factor for state space
            "--modules", "access_control,delegatecall,integer",  # Focus on access control and related issues
            "--parallel-solving",  # Enable parallel solving
            "--unconstrained-storage",  # Consider storage as unconstrained
            "--call-depth-limit", "3",  # Limit call depth
            "--strategy", "dfs",  # Use depth-first search strategy
            "--transaction-count", "3"  # Number of transactions to analyze
        ]
        
        print(f"Running Mythril analysis on {contract_path}...")
        print("Focusing on access control properties from Scribble annotations:")
        print("- msg.sender == admin")
        print("- msg.sender == pendingAdmin && msg.sender != address(0)")
        print("- msg.sender == admin || msg.sender == whitelistGuardian")
        
        result = subprocess.run(cmd, capture_output=True, text=True)
        
        if result.returncode == 0:
            print("\nAnalysis completed successfully!")
            print("Results:")
            print(result.stdout)
        else:
            print("\nAnalysis found potential issues:")
            print(result.stdout)
            print("\nErrors/Warnings:")
            print(result.stderr)
            
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
    
    # Run analysis on the Governor contract
    print("\n=== Starting GovernorBravoDelegate Analysis ===")
    run_mythril_analysis(str(governor_contract))
    print("\n=== Analysis Completed ===")

if __name__ == "__main__":
    main() 