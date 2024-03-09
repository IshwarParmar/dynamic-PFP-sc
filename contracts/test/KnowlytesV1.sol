 // SPDX-License-Identifier: MIT
 pragma solidity 0.8.4;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./StorageV1.sol";
 contract KnowlytesV1 is StorageV1,ERC721,Ownable{


    constructor(address _helper,bytes32 _rootHash) ERC721("Knowlytes","$KNOW"){
        StorageV1.rootHash = _rootHash;
        helper = _helper;


        //Initialize Mapping
        hatMap[1] = "Saliors Hat";
        hatMap[2] = "Cartoon";
        hatMap[3] = "Baseballer";
        hatMap[4] = "Sexy Chef";
        hatMap[5] = "Pirates";
        hatMap[6] = "Beach Party";
        hatMap[7] = "Street Boy";
        hatMap[8] = "Wizards";
        hatMap[9] = "Equestriane";
        hatMap[10] = "The Gentlemen";
        hatMap[11] = "Troops Mask";
        hatMap[12] = "Troops Mask 2";
        hatMap[13] = "Princess";
        hatMap[14] = "Magician Hat";

        jacketMap[1] = "Jacket1";
        jacketMap[2] = "Jacket2";
        jacketMap[3] = "Jacket3";
        jacketMap[4] = "Jacket4";
        jacketMap[5] = "Jacket5";
        jacketMap[6] = "Jacket6";
        jacketMap[7] = "Jacket7";
        jacketMap[8] = "Jacket8";
        jacketMap[9] = "Jacket9";
        jacketMap[10] = "Jacket10";
        jacketMap[11] = "Jacket11";
        jacketMap[12] = "Jacket12";
        jacketMap[13] = "Jacket13";
        jacketMap[14] = "Jacket14";

        hairMap[1] = "Hair1";
        hairMap[2] = "Hair2";
        hairMap[3] = "Hair3";
        hairMap[4] = "Hair4";
        hairMap[5] = "Hair5";
        hairMap[6] = "Hair6";
        hairMap[7] = "Hair7";
        hairMap[8] = "Hair8";
        hairMap[9] = "Hair9";
        hairMap[10] = "Hair10";
        hairMap[11] = "Hair11";
        hairMap[12] = "Hair12";
        hairMap[13] = "Hair13";

        noseMap[1] = "Nose1";
        noseMap[2] = "Nose2";
        noseMap[3] = "Nose3";
        noseMap[4] = "Nose4";
        noseMap[5] = "Nose5";
        noseMap[6] = "Nose6";
        noseMap[7] = "Nose7";
        noseMap[8] = "Nose8";

        glassMap[1] = "Glass1";
        glassMap[2] = "Glass2";
        glassMap[3] = "Glass3";
        glassMap[4] = "Glass4";
        glassMap[5] = "Glass5";
        glassMap[6] = "Glass6";
        glassMap[7] = "Glass7";
        glassMap[8] = "Glass8";

        earMap[1] = "Ear1";
        earMap[2] = "Ear2";
        earMap[3] = "Ear3";
        earMap[4] = "Ear4";
        earMap[5] = "Ear5";
        earMap[6] = "Ear6";
        earMap[7] = "Ear7";
        earMap[8] = "Ear8";

        backgroundMap[1] = "Blue";
        backgroundMap[2] = "Conference";
        backgroundMap[3] = "Construction";
        backgroundMap[4] = "Hospital";
        backgroundMap[5] = "Restaurant";
        backgroundMap[6] = "Yellow";
        backgroundMap[7] = "Green";
    }

    //Minting Functions
    function mintKnowlytes() external payable{
        uint256 tokenId = tokenIdCounter;
        require(StorageV1.isMintingPaused,"Minting Paused");
        require(tokenId<=maxSupply,"All NFT Minted!");
        if(msg.sender != owner()){
            require(msg.value >=price,"Invalid Amount");
        }
        tokenIdCounter++;
        updateNFTDetails(tokenIdCounter);
    }

    function whiteListKnowlytes(bytes32[] calldata proof) external payable{
        uint256 tokenId = tokenIdCounter;
        require(isWhiteListedPaused,"WhiteList Mint Paused");
        require(tokenId<=maxSupply,"All NFT Minted!");
        (bool success,) = helper.delegatecall(abi.encodeWithSignature("isWhiteListedAddress(bytes32[])",proof));
        if(!success) revert("Mint Failed");

        if (msg.sender != owner()) {
            require(msg.value >= preSalePrice, "Invalid Amount");
        }

        tokenIdCounter++;
        updateNFTDetails(tokenIdCounter);
        

    }


    function updateNFTDetails(uint256 tokenId) private{
        TokenMetaData storage nft = nftDetails[tokenId];
        nft.tokenId = tokenId;
        uint8 hat = nft.currentDetails.Hat.value = uint8(
            generateRandom(msg.sender, 14)
        );
        uint8 jacket = nft.currentDetails.Jacket.value = uint8(
            generateRandom(msg.sender, 14)
        );
        uint8 hair = nft.currentDetails.Hair.value = uint8(
            generateRandom(msg.sender, 13)
        );
        uint8 nose = nft.currentDetails.Nose.value = uint8(
            generateRandom(msg.sender, 8)
        );
        uint8 glass = nft.currentDetails.Glass.value = uint8(
            generateRandom(msg.sender, 8)
        );
        uint8 ear = nft.currentDetails.Ear.value = uint8(
            generateRandom(msg.sender, 8)
        );
        uint8 bg = nft.currentDetails.Background.value = uint8(
            generateRandom(msg.sender, 7)
        );

         updateTraitCounter(hat, jacket, hair, nose, glass, ear);

        _safeMint(msg.sender, tokenId);
        emit MintKnowlytes(tokenId, bg, hat, jacket, hair, nose, glass, ear);

    }


    function tokenURI(uint256 tokenId) public view override(ERC721) returns(string memory){
        require(_exists(tokenId),"ERC721Metadata : URI query for nonexistent token");
        StorageV1.TokenMetaData memory nft = StorageV1.nftDetails[tokenId];
        NFTData memory nftData;
        nftData.background = StorageV1.backgroundMap[nft.currentDetails.Background.value];
        nftData.hat = StorageV1.hatMap[nft.currentDetails.Hat.value];
        nftData.jacket = StorageV1.jacketMap[nft.currentDetails.Jacket.value];
        nftData.hair = StorageV1.hairMap[nft.currentDetails.Hair.value];
        nftData.nose = StorageV1.noseMap[nft.currentDetails.Nose.value];
        nftData.glass = StorageV1.glassMap[nft.currentDetails.Glass.value];
        nftData.ear = StorageV1.earMap[nft.currentDetails.Ear.value];

        if(StorageV1.isRevealed){
            (bool success, bytes memory data) = helper.staticcall(abi.encodeWithSignature("getTokenURI(uint256,string,NFTData)",tokenId,StorageV1.baseURI,nftData));
            require(success,"Tx Failed");
            return string(data);
        }
        return StorageV1.revealURI;
    }


    //Toggle Functions
    function toggleMinting() external onlyOwner {
        isMintingPaused = !isMintingPaused;
    }

    function toggleReveal() external onlyOwner {
        isRevealed = !isRevealed;
    }

    function toggleWhiteListMinting() external onlyOwner{
        isWhiteListedPaused = !isWhiteListedPaused;
    }

    // Setters Functions
    function setPrice(uint256 _newPrice) external onlyOwner {
        price = _newPrice;
    }
    function setBaseURI(string calldata _newURI) external onlyOwner {
        baseURI = _newURI;
    }
    function setRevealURI(string calldata _newURI) external onlyOwner {
        revealURI = _newURI;
    }


    function setManager(address _newManager)external onlyOwner{
        StorageV1.manager = _newManager;
    } 

    function updateTraitCounter(uint8 hat,uint8 jacket,uint8 hair,uint8 nose,uint8 glass,uint8 ear) private {
        traitCounter[1][hat] += 1;
        traitCounter[2][jacket] += 1;
        traitCounter[3][hair] += 1;
        traitCounter[4][nose] += 1;
        traitCounter[5][glass] += 1;
        traitCounter[6][ear] += 1;
    }

    // function withdraw()public onlyOwner{
    //     (bool success ,) = owner().call{value:address(this).balance}("");
    //     require(success,"Withdraw Failed");
    // }

    function changeTraits(uint256 tokenId,bytes32 data) external{
        require(ownerOf(tokenId)==msg.sender,"Not Owner of TokenID");
        (bool success,) = helper.delegatecall(abi.encodeWithSignature("changeTrait(uint256,bytes32)",tokenId,data));
        require(success,"Change Traits Failed");
    }

    // function freezeValues(uint8[][6] calldata min, uint256[][6] calldata totalId) external{
    //     require(min.length == 6, "Invalid Array");
    //     (bool success,) = helper.delegatecall(abi.encodeWithSignature("freezeValues(uint8[][6],uint8[][6])", min, totalId));
    //     require(success, "Freeze Value Failed");
    // }

    function generateRandom(address _account, uint256 range)private view returns (uint256){
        uint256 startToken = 0;
        return uint256(keccak256(abi.encodePacked(block.timestamp,_account,block.difficulty,startToken))) % range;
    }

 }