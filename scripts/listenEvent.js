const {ethers} = require('hardhat');
const abi = require('../artifacts/contracts/Knowlytes.sol/Knowlytes.json').abi;
const knowlytesAddress = "0xd28d76f4B2c5e1CEfeAf9a019867A4f5F0d09fBB";
const provider = new ethers.providers.InfuraProvider('goerli',process.env.INFURA_API)
const knowlytes = new ethers.Contract(knowlytesAddress,abi,provider);

const listenEvent = async()=>{
    knowlytes.on('MintedNFT',(tokenId,background,hat,jacket,hair,nose,glass,ear)=>{
        let info = {
            tokenId:tokenId,
            background:background,
            hat:hat,
            jacket:jacket,
            hair:hair,
            nose:nose,
            glass:glass,
            ear:ear
        };
        console.log(JSON.stringify(info,null,4))
    })    
}

const mintKnowlytes = async()=>{
    [owner] = await ethers.getSigners();
    await knowlytes.connect(owner).mintKnowlytes();
    // await knowlytes.connect(owner).mintKnowlytes();
    // await knowlytes.connect(owner).mintKnowlytes();
}

// mintKnowlytes();
listenEvent();






