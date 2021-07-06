const { ethers } = require("hardhat");
const { expect } = require("chai");
const { utils, constants } = require("ethers");

describe("GardenOfInfiniteLove", function() {
    let rootkit, paired, dev3, dev6, dev9, rootkitFeed, garden;

    beforeEach(async function() {
        [owner, dev3, dev6, dev9, rootkitFeed] = await ethers.getSigners();

        const rootkitFactory = await ethers.getContractFactory("RootKit");
        rootkit = await rootkitFactory.connect(owner).deploy();

        const pairedFactory = await ethers.getContractFactory("Paired");
        paired = await pairedFactory.connect(owner).deploy();

        const gardenFactory = await ethers.getContractFactory("GardenOfInfiniteLove");
        garden = await gardenFactory.connect(dev3).deploy(dev6.address, dev9.address, rootkit.address, rootkitFeed.address);
    })

    it("plants new seed", async function() {   
        await garden.connect(dev3).plantNewSeed(paired.address);
        const flowerAddress = await garden.pairedFlowers(paired.address, 0);
        const flower = await ethers.getContractAt("Octalily", flowerAddress);       
        await paired.connect(owner).approve(flowerAddress, constants.MaxUint256);

        await log(flower, "initial");

        flower.connect(owner).buy(utils.parseEther("100"));
        await log(flower, "buy with 100");

        flower.connect(owner).sell(await flower.balanceOf(owner.address));
        await log(flower, "sell all balance");

        flower.connect(owner).buy(utils.parseEther("100"));
        await log(flower, "buy with 100");

        flower.connect(owner).sell(await flower.balanceOf(owner.address));
        await log(flower, "sell all balance");

        flower.connect(owner).buy(utils.parseEther("10"));
        await log(flower, "buy with 10");

        flower.connect(owner).upOnly();
        await log(flower, "upOnly() 1");       
    })

    it("lets TheFlowersCoverTheEarth", async function() {  
        await garden.connect(dev3).plantNewSeed(paired.address);
        const flowerAddress = await garden.pairedFlowers(paired.address, 0);
        const flower = await ethers.getContractAt("Octalily", flowerAddress);       
        await paired.connect(owner).approve(flowerAddress, constants.MaxUint256);
        console.log("1")
        await flower.letTheFlowersCoverTheEarth();
        console.log("2")
        await flower.letTheFlowersCoverTheEarth();
        console.log("3")
        await flower.letTheFlowersCoverTheEarth();
        console.log("4")
        await flower.letTheFlowersCoverTheEarth();
        console.log("5")
        await flower.letTheFlowersCoverTheEarth();
        console.log("6")
        await flower.letTheFlowersCoverTheEarth();
        console.log("7")
        await flower.letTheFlowersCoverTheEarth();
        console.log("8")
        await flower.letTheFlowersCoverTheEarth();

    })

    async function log(flower, description) {
        console.log(description);
        console.log("flower total supply  ", (await flower.totalSupply()).toString());
        console.log("flower owner balance ", (await flower.balanceOf(owner.address)).toString());
        console.log("flower 69 balance    ", (await flower.balanceOf("0x6969696969696969696969696969696969696969")).toString());
        console.log("price                ", (await flower.price()).toString());
        console.log("");
    }
 
})