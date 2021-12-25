const { expect } = require("chai");
const { constants, utils } = require("ethers");
const { ethers } = require("hardhat");

describe("Rootflector", function() {
    let owner, user1, user2, user3, user4, user5, user6, user7, user8, user9, user0, users;
    let rootflector, simpleflector;

    beforeEach(async function() {
        [owner, user1, user2, user3, user4, user5, user6, user7, user8, user9, user0] = await ethers.getSigners();
        const rootflectorFactory = await ethers.getContractFactory("RootflectorTest");
        rootflector = await rootflectorFactory.connect(owner).deploy();

        const simpleflectorFactory = await ethers.getContractFactory("SimpleReflector");
        simpleflector = await simpleflectorFactory.connect(owner).deploy();

        await rootflector.connect(owner).setRootflectionFee(1000); //10%
        users = [user0, user1, user2, user3, user4, user5, user6, user7, user8, user9];
    })

    async function logBalances () {
        for(let i = 0; i < users.length; i++) {
            console.log(`user${i} balance ${utils.formatEther((await simpleflector.balanceOf(users[i].address)).toString())}`);
        }
        console.log("");
    }

    async function logRootflectorBalances () {
        for(let i = 0; i < users.length; i++) {
            console.log(`user${i} balance ` +utils.formatEther((await rootflector.balanceOf(users[i].address)).toString()));
        }
        // console.log("user0 pending " + utils.formatEther((await rootflector.pendingReward(user0.address)).toString()));
        // console.log("user1 pending " + utils.formatEther((await rootflector.pendingReward(user1.address)).toString()));
        // console.log("user0 paid    " + utils.formatEther((await rootflector.paid(user0.address)).toString()));
        // console.log("user1 paid    " + utils.formatEther((await rootflector.paid(user1.address)).toString()));
        // console.log(`this balance  ${utils.formatEther((await rootflector.balanceOf(rootflector.address)).toString())}`);
        // console.log(`total paid    ${utils.formatEther((await rootflector.totalPaid()).toString())}`);
        console.log("");
    }

    it("owner transfers 100 to user1", async function() {
        for(let i = 0; i < users.length; i++) {
            await simpleflector.connect(owner).transfer(users[i].address, utils.parseEther("1000"));
            await simpleflector.connect(owner).addHolder(users[i].address);

            await rootflector.connect(owner).transfer(users[i].address, utils.parseEther("1000"));
        }

        //await logBalances();
        await logRootflectorBalances();

        await simpleflector.connect(owner).enableRootflection();
        await rootflector.connect(owner).enableRootflection();

        // for (let i = 0; i < 10; i++) {
        //     await simpleflector.connect(user0).transfer(user1.address, utils.parseEther("100"));
        //     await logBalances();
        //     await simpleflector.connect(user1).transfer(user0.address, utils.parseEther("100"));
        //     await logBalances();
        // }

        for (let i = 0; i < 30; i++) {
            const amount = utils.parseEther("100");
            await rootflector.connect(user0).transfer(user1.address, amount);
            await logRootflectorBalances();
            await rootflector.connect(user1).transfer(user0.address, amount);
            await logRootflectorBalances();
        }
        
    })

    // describe("owner transfers 100 to user1", function() {
    //     beforeEach(async function() {
    //         await rootflector.connect(owner).transfer(user1.address, utils.parseEther("100"));
    //     })

    //     it("initializes as expected", async function() {
    //     //    expect(await rootflector.balanceOf(owner.address)).to.gt(utils.parseEther("9900"));
    //     //    expect(await rootflector.balanceOf(user1.address)).to.gt(utils.parseEther("90"));
    //     //    expect(await rootflector.balanceOf(rootflector.address)).to.equal(utils.parseEther("10"));

    //     //    expect(await rootflector.lastPaid(owner.address)).to.equal(utils.parseEther("0"));
    //     //    expect(await rootflector.lastPaid(user1.address)).to.equal(utils.parseEther("0"));

    //     //    expect(await rootflector.pendingReward(owner.address)).to.equal(utils.parseEther("9.9"));
    //     //    expect(await rootflector.pendingReward(user1.address)).to.equal(utils.parseEther("0.09"));
    //        //console.log((await rootflector.pendingReward(user1.address)).toString());
    //        console.log(utils.formatEther((await rootflector.lastPaid(owner.address)).toString()));
    //        console.log(utils.formatEther((await rootflector.pendingReward(owner.address)).toString()));
    //     })

    //     describe("owner transfers 100 to user2", function() {
    //         beforeEach(async function() {
    //             await rootflector.connect(owner).transfer(user2.address, utils.parseEther("100"));
    //         })

    //         it("initializes as expected", async function() {
    //             console.log(utils.formatEther((await rootflector.lastPaid(owner.address)).toString()));
    //             console.log(utils.formatEther((await rootflector.pendingReward(owner.address)).toString()));
    //             // expect(await rootflector.lastPaid(owner.address)).to.equal(utils.parseEther("9.9"));
    //             // expect(await rootflector.balanceOf(rootflector.address)).to.equal(utils.parseEther("10.1"));
    
            
    //             // console.log((await rootflector.pendingReward(owner.address)).toString());
    //             //console.log((await rootflector.pendingReward(user1.address)).toString());
    //             //console.log((await rootflector.pendingReward(user2.address)).toString());
    //         })

    //         it("owner transfers 100 to user1", async function() {
    //             for(let i = 0; i < 40; i++) {
    //                 await rootflector.connect(owner).transfer(user1.address, utils.parseEther("200"));
    //                 console.log("owner balance           " + utils.formatEther((await rootflector.balanceOf(owner.address)).toString()));
    //                 console.log("user1 balance           " + utils.formatEther((await rootflector.balanceOf(user1.address)).toString()));
    //                 console.log("owner total paid        " + utils.formatEther((await rootflector.totalPaid(owner.address)).toString()));
    //                 console.log("owner pending rewards   " + utils.formatEther((await rootflector.pendingReward(owner.address)).toString()));
    //                 console.log("user1 pending rewards   " + utils.formatEther((await rootflector.pendingReward(user1.address)).toString()));
    //                 console.log("total rewards           " + utils.formatEther((await rootflector.balanceOf(rootflector.address)).toString()));
    //                 console.log("");
    //             }

               
    //             console.log("");
    //             console.log("");
    //             await rootflector.connect(user1).transfer(user2.address, utils.parseEther("6000"));
    //             console.log("owner total paid        " + utils.formatEther((await rootflector.totalPaid(owner.address)).toString()));
    //             console.log("user1 total paid        " + utils.formatEther((await rootflector.totalPaid(user1.address)).toString()));
    //             console.log("owner pending rewards   " + utils.formatEther((await rootflector.pendingReward(owner.address)).toString()));
    //             console.log("user1 pending rewards   " + utils.formatEther((await rootflector.pendingReward(user1.address)).toString()));

    //         })
    //     })       
   // })

});