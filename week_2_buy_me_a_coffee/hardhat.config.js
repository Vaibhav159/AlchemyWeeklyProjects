require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-ethers");
require("dotenv").config();

const GOERLI_URL = process.env.GOERLI_URL;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const TAIKO_URL = process.env.TAIKO_URL;
const TAIKO_PRIVATE_KEY = process.env.TAIKO_PRIVATE_KEY;

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.4",
  networks: {
    goerli: {
      url: GOERLI_URL,
      accounts: [PRIVATE_KEY]
    },
    taiko: {
      url: TAIKO_URL,
      accounts: [TAIKO_PRIVATE_KEY]
    }
  }
};
