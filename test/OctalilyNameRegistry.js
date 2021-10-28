const { ethers } = require("hardhat");
const { expect } = require("chai");
const { utils, constants } = require("ethers");

describe("OctalilyNameRegistry", function() {
    let rootkit, paired, dev3, dev6, dev9, rootkitFeed, garden, flowerAddress, nameRegistry;

    beforeEach(async function() {
        [owner, dev3, dev6, dev9, rootkitFeed] = await ethers.getSigners();

        const rootkitFactory = await ethers.getContractFactory("RootKit");
        rootkit = await rootkitFactory.connect(owner).deploy();

        const pairedFactory = await ethers.getContractFactory("Paired");
        paired = await pairedFactory.connect(owner).deploy();

        const gardenFactory = await ethers.getContractFactory("GardenOfInfiniteLove");
        garden = await gardenFactory.connect(dev3).deploy(dev6.address, dev9.address, rootkit.address, rootkitFeed.address, utils.parseUnits("696969", 12));
        await garden.connect(dev3).plantNewSeed(paired.address);
        flowerAddress = await garden.pairedFlowers(paired.address, 0);

        const nameRegistryFactory = await ethers.getContractFactory("OctalilyNameDescriptionRegistry");
        nameRegistry = await nameRegistryFactory.connect(owner).deploy();
    })

    it("Sets name", async function() {
        await nameRegistry.connect(dev3).setMultiOwnedName(flowerAddress, "Flower");
        expect(await nameRegistry.names(flowerAddress)).to.equal("Flower");        
    })

    it("Can't set name from non-owner", async function() {
        await expect(nameRegistry.connect(dev6).setMultiOwnedName(flowerAddress, "Flower")).to.be.revertedWith("Owner only");
    })

    it("Can't set name that more than 32 characters", async function() {
        await expect(nameRegistry.connect(dev6).setMultiOwnedName(flowerAddress, "Flower Flower Flower Flower Flower Flower Flower")).to.be.revertedWith("Too long");
    })
})