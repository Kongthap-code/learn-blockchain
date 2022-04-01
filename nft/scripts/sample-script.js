const hre = require("hardhat");

async function main() {
  const [KCoin,NFT,NFTLand] = await Promise.all([
    hre.ethers.getContractFactory("KCoin"),
    hre.ethers.getContractFactory("NFT"),
    hre.ethers.getContractFactory("NFTLand")
  ])

  const kcoin = await KCoin.deploy();
  await kcoin.deployed();
  console.log("KCoin deployed to address:", kcoin.address);

  const nft = await NFT.deploy();
  await nft.deployed();
  console.log("NFT deployed to address:", nft.address);

  const nftland = await NFTLand.deploy("");
  await nftland.deployed();
  console.log("NFTLand deployed to address:", nftland.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
