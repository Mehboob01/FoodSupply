require('dotenv').config(); // Import the dotenv package

require('@nomiclabs/hardhat-waffle');
require('@nomiclabs/hardhat-etherscan');
require("@nomiclabs/hardhat-ethers");

task('accounts', 'Prints the list of accounts', async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

const privateKey = process.env.PRIVATE_KEY; // Retrieve the private key from the .env file
const etherscanAPIKey = process.env.API_KEY; // Retrieve the Etherscan API key from the .env file

  module.exports = {
    solidity: {
      version: '0.8.18',
      settings: {
        optimizer: {
          enabled: true,
          runs: 200,
        },
      },
    },
    networks: {
      BSC: {
        url: 'https://data-seed-prebsc-2-s3.binance.org:8545',
        accounts: [privateKey],
      },
      mainnet: {
        url: 'https://mainnet.infura.io/v3/PROJECT_ID',
        accounts: [privateKey],
      },
    },
    etherscan: {
      apiKey: etherscanAPIKey,
    },
  };