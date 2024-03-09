const { expect } = require("chai");
const { ethers } = require("hardhat");
const {
  BN,
  ether,
  expectEvent,
  expectRevert,
  time,
} = require("@openzeppelin/test-helpers");
const rootHash = require("../scripts/merkle").rootHash;
const proof = require("../scripts/merkle").proof;

describe("Knowlytes Testcases", () => {
  let Knowlytes;
  let knowlytes;
  let KnowlytesHelper;
  let knowlyteshelper;

  beforeEach(async () => {
    [owner, addr1, addr2, addr3] = await ethers.getSigners();
    KnowlytesHelper = await ethers.getContractFactory("KnowlytesV1Helper");
    knowlyteshelper = await KnowlytesHelper.deploy();
    Knowlytes = await ethers.getContractFactory("KnowlytesV1");
    knowlytes = await Knowlytes.deploy(knowlyteshelper.address, rootHash);
    await knowlytes.deployed();
  });

  describe("Init", async () => {
    it("should be initialize", async () => {
      expect(knowlyteshelper).to.be.ok;
      expect(knowlytes).to.be.ok;
    });
  });

  describe("Contract Deployment", async () => {
    it("should have correct name", async () => {
      const name = await knowlytes.name();
      console.log(name);
      expect(name.toString()).to.be.equals("Knowlytes");
    });
    it("should have correct symbol", async () => {
      const symbol = await knowlytes.symbol();
      expect(symbol).to.be.equals("$KNOW");
    });
    it("max supply should be 1111", async () => {
      expect(await knowlytes.maxSupply()).to.be.equals(1111);
    });
    it("should emit MintKnowlytes event when we mint nft", async () => {
      await knowlytes.connect(owner).toggleMinting();
      await expect(knowlytes.connect(owner).mintKnowlytes()).to.emit(
        knowlytes,
        "MintKnowlytes"
      );
    });
  });

  describe("Mint Knowlytes", async () => {
    it("should revert if non-owner mint price not pay", async () => {
      await knowlytes.connect(owner).toggleMinting();
      await expect(knowlytes.connect(addr1).mintKnowlytes()).to.be.revertedWith(
        "Invalid Amount"
      );
    });
    it("should not charge mint price if owner", async () => {
      await knowlytes.connect(owner).toggleMinting();
      await knowlytes.connect(owner).mintKnowlytes();

      const ownerAddress = await knowlytes.ownerOf(1);
      expect(ownerAddress).to.be.equals(owner.address);
    });
    it("should not revert if mint price pay by non owner", async () => {
      await knowlytes.connect(owner).toggleMinting();
      await expect(
        knowlytes
          .connect(addr1)
          .mintKnowlytes({ value: ethers.utils.formatEther("5000000000000") })
      ).not.to.be.revertedWith("Invalid Amount");
    });
    it("should revert with minting is paused", async () => {
      // await knowlytes.connect(owner).togglePause();
      await expect(knowlytes.mintKnowlytes()).to.be.revertedWith(
        "Minting Paused"
      );
    });
  });

  describe("Mint WhiteList Knowlytes", async () => {
    it("should revert if whitelist not enable", async () => {
      await expect(knowlytes.whiteListKnowlytes(proof)).to.be.revertedWith(
        "WhiteList Mint Paused"
      );
    });
    it("should revert if user is not in whitelist", async () => {
      await knowlytes.connect(owner).toggleWhiteListMinting();
      await expect(
        knowlytes.connect(addr1).whiteListKnowlytes(proof)
      ).to.be.revertedWith("Mint Failed");
    });
    it("should able to mint if in whitelist and whitelist enable", async () => {
      await knowlytes.toggleWhiteListMinting();
      await knowlytes.connect(owner).whiteListKnowlytes(proof);
      expect(await knowlytes.ownerOf(1)).to.be.equals(owner.address);
    });
    it("should emit event Mint Knowlytes", async () => {
      await knowlytes.connect(owner).toggleWhiteListMinting();
      await expect(knowlytes.connect(owner).whiteListKnowlytes(proof)).to.emit(
        knowlytes,
        "MintKnowlytes"
      );
    });
  });

  describe("Only Owner", async () => {
    it("Only Owner can change Price of Knowlytes", async () => {
      console.log("owner", owner.address);
      await expect(
        knowlytes.connect(addr1).setPrice(ethers.utils.parseEther("0.5"))
      ).to.be.revertedWith("Ownable: caller is not the owner");
    });
    it("Only Owner can Toggle Pause functionality", async () => {
      await expect(knowlytes.connect(addr1).toggleMinting()).to.be.revertedWith(
        "Ownable: caller is not the owner"
      );
    });
    it("Only Owner can Toggle WhiteList functionality", async () => {
      await expect(
        knowlytes.connect(addr1).toggleWhiteListMinting()
      ).to.be.revertedWith("Ownable: caller is not the owner");
    });
    it("Only Owner can Withdraw Minted Knowlytes Price", async () => {
      const balanceBeforeMint = await ethers.provider.getBalance(
        knowlytes.address
      );
      console.log(`Balance Before Minting: ${balanceBeforeMint}`);
      await knowlytes.connect(owner).toggleMinting();
      await knowlytes
        .connect(addr1)
        .mintKnowlytes({ value: ethers.utils.parseEther("0.0005") });
      const balanceAfterMint = await ethers.provider.getBalance(
        knowlytes.address
      );
      console.log(`Balance After Minting: ${balanceAfterMint}`);
      console.log(
        `Owner Balance Before Withdrawal: ${await ethers.provider.getBalance(
          owner.address
        )}`
      );
      await knowlytes.connect(owner).withdraw();
      console.log(
        `Owner Balance After Withdrawal: ${await ethers.provider.getBalance(
          owner.address
        )}`
      );
      expect(await ethers.provider.getBalance(knowlytes.address)).to.be.equals(
        "0"
      );
    });
    it("Should revert if Non-Owner set Manager", async () => {
      await expect(
        knowlytes.connect(addr1).setManager(addr3.address)
      ).to.be.revertedWith("Ownable: caller is not the owner");
    });
    it("Only Owner can Set New Manager", async () => {
      await knowlytes.connect(owner).setManager(addr3.address);
      const manager = await knowlytes.manager();
      expect(manager).to.be.equals(addr3.address);
    });
  });

  describe("Change Traits", async () => {
    it("User can change Traits Once in a Month Only", async () => {
      let currentTokenId = await knowlytes.tokenIdCounter();
      await knowlytes.connect(owner).toggleMinting();
      await knowlytes.mintKnowlytes();
      currentTokenId = await knowlytes.tokenIdCounter();
      await knowlytes
        .connect(owner)
        .changeTraits(
          currentTokenId,
          "0x506ada9456799872b361a2ee98cde5504a4dc41ec3fe745a633235764265f5eb"
        );
      const details = await knowlytes.nftDetails(currentTokenId);
      expect(details.hashedProof).to.be.hexEqual(
        "0x506ada9456799872b361a2ee98cde5504a4dc41ec3fe745a633235764265f5eb"
      );
      expect(details.haveChanged).to.be.true;
      expect(details.changedMonth.toNumber()).to.be.greaterThan(0);
    });
    it("Should revert if user change twice in same month",async()=>{
      let currentTokenId = await knowlytes.tokenIdCounter();
      await knowlytes.connect(owner).toggleMinting();
      await knowlytes.mintKnowlytes();
      currentTokenId = await knowlytes.tokenIdCounter();
      await knowlytes.connect(owner).changeTraits(currentTokenId,"0x506ada9456799872b361a2ee98cde5504a4dc41ec3fe745a633235764265f5eb");
      await  expect(knowlytes.connect(owner).changeTraits(currentTokenId,"0x506ada9456799872b361a2ee98cde5504a4dc41ec3fe745a633235764265f5eb")).to.be.revertedWith("Change Traits Failed")
    })
  });

  describe("Freeze Testacases",async()=>{
    it("should freeze tokenIDs and Trait Values", async()=>{
      await knowlytes.connect(owner).toggleMinting();
      await knowlytes.connect(owner).mintKnowlytes();
      // const val = StorageV1.nftDetails[1].currentDetails.Hat.isFreezed;
      
      const detail= await knowlytes.nftDetails(1);
      // const newAr = detail.currentDetails.map(myArray);
      // function myArray(num){return num.value}
      const val = detail.currentDetails.Hat.value;
      const values = [[val], [], [],[], [], []];
      const tId = [[1], [], [],[], [], []];

      await knowlytes.connect(owner).setManager(addr1.address);
      await knowlytes.connect(addr1).freezeValues(values, tId);
      // console.log(await knowlytes.hatFreezedMap(val));
      const boo = await knowlytes.hatFreezedMap(val);
      const bo = await knowlytes.nftDetails(1);
      // console.log(bo.currentDetails.Hat.isFreezed);
      expect(boo).to.equal(true);
      expect(bo.currentDetails.Hat.isFreezed).to.equal(true);
    })
  })
});
