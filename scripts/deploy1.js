const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  console.log("Account balance:", (await deployer.getBalance()).toString());
 
  // pass value as a constructor
  // const token = "0xfCacB1e616F0Aa55378a68fb3A815444CFF9f9fc";
  
  const preSale = await ethers.getContractFactory("preSale");
  const presale = await preSale.deploy();
  await presale.deployed();

  console.log("Contract address:", presale.address);

  if (network.name !== "hardhat") {
    console.log("Verifying contract on BSC Testnet Network...");
    try {
      await run("verify:verify", {
        address: presale.address,
        constructorArguments: [], // Pass the actual values here
      });
      console.log("Contract verified on BSC Testnet Network!");
    } catch (error) {
      console.error("Failed to verify contract on BSC Testnet Network:", error);
    }
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
