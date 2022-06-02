const { ethers, upgrades } = require("hardhat");

  async function main() {
    // // Deploying by proxy
    // const Lottery = await ethers.getContractFactory("Lottery");
    // const L = await upgrades.deployProxy(Lottery);
    // await L.deployed();
    // console.log("Lottery proxy address:", L.address);
  
  
    // // Upgrading
    // const Lottery = await ethers.getContractFactory("Lottery");
    // const upgraded = await upgrades.upgradeProxy(L.address, Lottery);
    // console.log("upgraded successfully.");


    // simple deploy
    const Lottery = await ethers.getContractFactory("Lottery");
    const L = await Lottery.deploy();
    await L.deployed();
    console.log("Lottery Contract Address:", L.address);
    
  }
    
  main();