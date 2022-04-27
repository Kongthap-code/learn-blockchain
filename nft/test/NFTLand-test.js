const { expect } = require("chai");
const { ethers } = require("hardhat");
require("dotenv").config();

describe("NFTLand", function () {
  this.timeout(0);

  let NFTLand;
  let nftland;
  let signers;

  this.beforeEach(async () => {
    signers = await ethers.getSigners();

    NFTLand = await ethers.getContractFactory("NFTLand");
    nftland = await NFTLand.deploy(process.env.K_COIN, process.env.NFT);
    await nftland.deployed();
  });

  it("Should be able to getAllTokens", async function () {
    expect(await nftland.getAllTokens()).to.be.instanceof(Array);
    console.log(await nftland.getAllTokens());
  });
});
