const { ethers } = require("hardhat");
const rootHash = require("./merkle").rootHash;
async function main() {
  const Knowlytes = await ethers.getContractFactory("KnowlytesV2");
  const KnowlytesHelper = await ethers.getContractFactory("KnowlytesHelperV2");
  const knowlyteshelperv1  = await KnowlytesHelper.deploy();
  const knowlytes = await Knowlytes.deploy(knowlyteshelperv1.address,rootHash);
  await knowlyteshelperv1.deployed();
  await knowlytes.deployed();
  console.log("KnowlytesV2 Address:",knowlytes.address);
}
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

