require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
require('@openzeppelin/hardhat-upgrades');
require("@nomiclabs/hardhat-ethers");

const { PRIVATE_KEY, ALCHEMY_API_KEY, POLYGONSCAN_API_KEY, ETHERSCAN_API_KEY, SNOWTRACE_API_KEY } = require('./secret.json');

module.exports = {
  solidity: "0.8.11",
  networks: {
    polygon: {
      url: `https://polygon-mainnet.g.alchemy.com/v2/${ALCHEMY_API_KEY}`,
      accounts: [`0x${PRIVATE_KEY}`],
    },
    polygonMumbai: {
      url: `https://matic-mumbai.chainstacklabs.com`,
      accounts: [`0x${PRIVATE_KEY}`],
    },
    rinkeby: {
      url: `https://rinkeby.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161`,
      accounts: [`0x${PRIVATE_KEY}`],
    },
    kovan: {
      url: `https://eth-kovan.alchemyapi.io/v2/${ALCHEMY_API_KEY}`,
      accounts: [`0x${PRIVATE_KEY}`],
    },
    avalancheFujiTestnet: {
      url: `https://api.avax-test.network/ext/bc/C/rpc`,
      accounts: [`0x${PRIVATE_KEY}`],
    },
  },
  etherscan: {
    apiKey: {
      mainnet: `${ETHERSCAN_API_KEY}`,
      ropsten: `${ETHERSCAN_API_KEY}`,
      rinkeby: `${ETHERSCAN_API_KEY}`,
      goerli: `${ETHERSCAN_API_KEY}`,
      kovan: `${ETHERSCAN_API_KEY}`,

      // binance smart chain
      // bsc: "YOUR_BSCSCAN_API_KEY",
      // bscTestnet: "YOUR_BSCSCAN_API_KEY",


      // polygon
      polygon: `${POLYGONSCAN_API_KEY}`,
      polygonMumbai: `${POLYGONSCAN_API_KEY}`,

      
      // avalanche
      avalanche: `${SNOWTRACE_API_KEY}`,
      avalancheFujiTestnet: `${SNOWTRACE_API_KEY}`,
      
      // xdai and sokol don't need an API key, but you still need
      // to specify one; any string placeholder will work
      // xdai: "api-key",
      // sokol: "api-key",
    }
  },
};
