require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
require("hardhat-contract-sizer");
require("dotenv").config();

module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.8.4",
      },
      {
        version: "0.8.9",
      },
      {
        version: "0.8.5",
      },
    ],
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
    hardhat: {
      allowUnlimitedContractSize: true,
    },
    goreli: {
      url: `https://goerli.infura.io/v3/${process.env.INFURA_API} `,
      accounts: [process.env.privateKey],
    },
  },

  contractSizer: {
    alphaSort: true,
    runOnCompile: true,
    disambiguatePaths:false,
    strict: true,
  },

  etherscan: {
    apiKey: {
      goerli: process.env.ETHERSCAN_API,
    },
  },
};
