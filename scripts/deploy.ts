import { ethers } from "hardhat";

async function main() {
  const GovBravoDelegate = await ethers.getContractFactory("GovernorBravoDelegate");
  const govBravoDelegate = await GovBravoDelegate.deploy();
  await govBravoDelegate.waitForDeployment();

  console.log("GovernorBravoDelegate deployed to:", await govBravoDelegate.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
}); 