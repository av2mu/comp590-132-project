import { ethers } from "hardhat";

async function main() {
  const SimpleDAO = await ethers.getContractFactory("SimpleDAO");
  const dao = await SimpleDAO.deploy();
  await dao.waitForDeployment();

  console.log("SimpleDAO deployed to:", await dao.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
}); 