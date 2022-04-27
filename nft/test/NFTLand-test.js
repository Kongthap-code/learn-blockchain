const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("NFTLand", function () {
  this.timeout(0);

  let NFTLand;
  let nftland;
  let signers;

  this.beforeEach(async () => {
    signers = await ethers.getSigners();

    NFTLand = await ethers.getContractFactory("NFTLand");
    nftland = await NFTLand.deploy(
      "0x51cBd8a974C57e88Cb87959404a3cF33B5e35e04",
      "0x8c6f5a906DDb38dC3203aB631d2561A85acD2bb3"
    );
    await nftland.deployed();
  });

  it("Should be able to getAllTokens", async function () {
    expect(await nftland.getAllTokens()).to.be.instanceof(Array);
    console.log(await nftland.getAllTokens());
  });
});
