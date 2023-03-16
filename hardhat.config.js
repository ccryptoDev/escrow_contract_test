require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
require("@nomiclabs/hardhat-ethers");
const { mnemonic, infuraKey, BSCSCAN_API_KEY } = require('./secrets.json');

module.exports = {
    networks: {
        ropsten: {
            url: "https://ropsten.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161"
        },
        fantom: {
            url: "https://rpcapi.fantom.network",
            // url: "https://rpcapi.fantom.network",
            accounts: { mnemonic: mnemonic },
            chainId: 250,
            live: true,
            saveDeployments: true,
            gasPrice: 22000000000,
            // gasMultiplier: 2,
        },
        fantomtest: {
            url: "https://rpc.testnet.fantom.network",
            accounts: { mnemonic: mnemonic },
            chainId: 4002,
            live: true,
            saveDeployments: true,
            tags: ["staging"],
            gasMultiplier: 2,
            // url: 'https://xapi.testnet.fantom.network/lachesis',
            // tags: ['test', 'legacy', 'use_root'],
            // chainId: 4002,
            // accounts: { mnemonic: mnemonic }
            // gas: 2100000,
            // gasPrice: 3000000000
        },
        mumbai: {
            url: "https://matic-testnet-archive-rpc.bwarelabs.com",
            // url: `https://polygon-mumbai.infura.io/v3/${infuraKey}`,
            accounts: { mnemonic: mnemonic }
        },
        matic: {
            url: "https://rpc-mumbai.maticvigil.com",
            accounts: { mnemonic: mnemonic }
        },
        rinkeby: {
            url: `https://rinkeby.infura.io/v3/` + infuraKey,
            accounts: { mnemonic: mnemonic }
        },
        eth: {
            url: `https://mainnet.infura.io/v3/` + infuraKey,
            accounts: { mnemonic: mnemonic }
        },
        bsctest: {
            url: "https://data-seed-prebsc-1-s1.binance.org:8545",
            chainId: 97,
            gas: 2100000,
            gasPrice: 20000000000,
            accounts: { mnemonic: mnemonic }
        },
    },
    solidity: {
        version: "0.8.1",
        settings: {
            optimizer: {
                enabled: true,
                runs: 1000,
            },
        },
    },
    etherscan: {
        apiKey: BSCSCAN_API_KEY,
    },

};