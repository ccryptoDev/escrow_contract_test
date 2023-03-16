const { ethers } = require("hardhat");

async function main() {
    const VendorInstance = await ethers.getContractFactory("Vendor");
    const VendorContract = await VendorInstance.deploy("0xf1f0d12A15e5E2e0815Ef81c5B6c5d03E5Ef859A");
    console.log("_Vendor Contract is deployed to:", VendorContract.address);
}

main();