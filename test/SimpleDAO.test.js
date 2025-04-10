const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("SimpleDAO", function () {
  let SimpleDAO;
  let dao;
  let owner;
  let addr1;
  let addr2;
  let addr3;
  let addrs;

  beforeEach(async function () {
    // Get the ContractFactory and Signers here.
    SimpleDAO = await ethers.getContractFactory("SimpleDAO");
    [owner, addr1, addr2, addr3, ...addrs] = await ethers.getSigners();

    // Deploy a new SimpleDAO contract before each test
    dao = await SimpleDAO.deploy();
    await dao.waitForDeployment();
  });

  describe("Deployment", function () {
    it("Should set the right admin", async function () {
      expect(await dao.admin()).to.equal(owner.address);
    });
  });

  describe("Proposal Creation", function () {
    it("Should allow admin to create a proposal", async function () {
      await dao.createProposal("Test proposal", 86400); // 1 day
      const proposal = await dao.getProposal(0);
      expect(proposal.description).to.equal("Test proposal");
      expect(proposal.startTime).to.be.above(0);
      expect(proposal.endTime).to.equal(proposal.startTime + 86400n);
      expect(proposal.executed).to.equal(false);
    });

    it("Should not allow non-admin to create a proposal", async function () {
      await expect(
        dao.connect(addr1).createProposal("Test proposal", 86400)
      ).to.be.revertedWith("Only admin can call this function");
    });

    it("Should not allow invalid voting period", async function () {
      await expect(
        dao.createProposal("Test proposal", 0)
      ).to.be.revertedWith("Invalid voting period");
      await expect(
        dao.createProposal("Test proposal", 8 * 24 * 60 * 60) // 8 days
      ).to.be.revertedWith("Invalid voting period");
    });
  });

  describe("Voting", function () {
    beforeEach(async function () {
      await dao.createProposal("Test proposal", 86400);
      await dao.setTokenBalance(addr1.address, 100);
      await dao.setTokenBalance(addr2.address, 200);
    });

    it("Should allow token holders to vote", async function () {
      await dao.connect(addr1).vote(0, true);
      const proposal = await dao.getProposal(0);
      expect(proposal.yesVotes).to.equal(100n);
    });

    it("Should not allow non-token holders to vote", async function () {
      await expect(
        dao.connect(addr3).vote(0, true)
      ).to.be.revertedWith("Must be a token holder");
    });

    it("Should not allow double voting", async function () {
      await dao.connect(addr1).vote(0, true);
      await expect(
        dao.connect(addr1).vote(0, true)
      ).to.be.revertedWith("Already voted");
    });

    it("Should not allow voting outside the time window", async function () {
      // Advance time beyond the voting period
      await ethers.provider.send("evm_increaseTime", [86401]);
      await ethers.provider.send("evm_mine");
      
      await expect(
        dao.connect(addr1).vote(0, true)
      ).to.be.revertedWith("Voting ended");
    });
  });

  describe("Finalization", function () {
    beforeEach(async function () {
      await dao.createProposal("Test proposal", 86400);
      await dao.setTokenBalance(addr1.address, 100);
      await dao.setTokenBalance(addr2.address, 200);
      await dao.connect(addr1).vote(0, true);
      await dao.connect(addr2).vote(0, false);
      
      // Advance time beyond the voting period
      await ethers.provider.send("evm_increaseTime", [86401]);
      await ethers.provider.send("evm_mine");
    });

    it("Should allow finalizing a proposal after voting period", async function () {
      await dao.finalize(0);
      const proposal = await dao.getProposal(0);
      expect(proposal.executed).to.equal(true);
    });

    it("Should not allow finalizing a proposal before voting period ends", async function () {
      // Create a new proposal
      await dao.createProposal("Test proposal 2", 86400);
      
      await expect(
        dao.finalize(1)
      ).to.be.revertedWith("Voting still in progress");
    });

    it("Should not allow finalizing an already executed proposal", async function () {
      await dao.finalize(0);
      await expect(
        dao.finalize(0)
      ).to.be.revertedWith("Proposal already executed");
    });
  });

  describe("Token Balance Management", function () {
    it("Should allow admin to set token balances", async function () {
      await dao.setTokenBalance(addr1.address, 100);
      expect(await dao.tokenBalances(addr1.address)).to.equal(100n);
    });

    it("Should not allow non-admin to set token balances", async function () {
      await expect(
        dao.connect(addr1).setTokenBalance(addr2.address, 100)
      ).to.be.revertedWith("Only admin can call this function");
    });
  });
}); 