const hre = require('hardhat');

async function main() {
    const bootsForLife = await hre.ethers.getContractFactory("bootsForLife");
    const bootsForLifeInstance = await bootsForLife.deploy();
    await bootsForLifeInstance.deployed();
    console.log("Contract Deployed At",bootsForLifeInstance.address);
}


main().then(() => {
    process.exit(0);
    }
).catch(e => {
    console.error(e);
    process.exit(1);
}
);