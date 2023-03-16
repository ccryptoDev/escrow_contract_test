const { ethers } = require("hardhat");

async function main() {
    const TokenInstance = await ethers.getContractFactory("LPToken");
    const OmbTokenContract = await TokenInstance.deploy();
    console.log("_2OMB_Token Contract is deployed to:", OmbTokenContract.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });