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
            "--modules", "access_control",  # Focus specifically on access control
            "--parallel-solving",  # Enable parallel solving
            "--unconstrained-storage",  # Consider storage as unconstrained
            "--call-depth-limit", "3",  # Limit call depth
            "--strategy", "dfs",  # Use depth-first search strategy
            "--transaction-count", "3",  # Number of transactions to analyze
            "--verbose",  # Enable verbose output
            "--show-all-states",  # Show all states in the analysis
            "--enable-iprof",  # Enable instruction profiling
            "--enable-coverage-strategy",  # Enable coverage strategy
            "--enable-summaries",  # Enable function summaries
            "--enable-dependency-pruning",  # Enable dependency pruning
            "--enable-physics",  # Enable physics-based analysis
            "--enable-constraint-solving"  # Enable constraint solving
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
        print("  - Transaction count: 3")
        print("  - Modules: access_control")
        
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
    
    # Run analysis on the Governor contract
    print("\n=== Starting GovernorBravoDelegate Analysis ===")
    run_mythril_analysis(str(governor_contract))
    print("\n=== Analysis Completed ===")

if __name__ == "__main__":
    main() 