// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Storage.sol";

contract Knowlytes is Storage, ERC721, Ownable {
    //Events
    event MintKnowlytes(
        uint256 indexed tokenId,
        uint8 bg,
        uint8 hat,
        uint8 jacket,
        uint8 hair,
        uint8 nose,
        uint8 glass,
        uint8 ear
    );

    constructor(
        /*bytes32 _rootHash*/
        address _helperAddress
    ) ERC721("Knowlytes", "$KNOW") {
        Storage
            .rootHash = 0xa1145b2cc45e8f24fa625b517b862a3bc0e16f3e02323791276acbefdb770a8b;
        helperAddress = _helperAddress;

        //Initialize Tarits Mapping

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
    
    function mintKnowlytes() external payable {
        uint256 tokenId = tokenIdCounter;
        require(Storage.isMintingPaused, "Minting Paused");
        require(tokenId <= Storage.maxSupply, "All NFT Minted!");
        if (msg.sender != owner()) {
            require(msg.value >= Storage.price, "Invalid Amount");
        }
        tokenIdCounter++;
        updateNFTDetails(tokenIdCounter);
    }

    function whiteListKnowlytes(
        address _helperAddress,
        bytes32[] calldata proof
    ) external payable {
        uint256 tokenId = tokenIdCounter;
        (bool isEligible, ) = _helperAddress.delegatecall(
            abi.encodeWithSignature(
                "isEligibleToWhiteListMint(uint256,bytes32[])",
                tokenId,
                proof
            )
        );
        if (!isEligible) revert("TX Failed");

        if (msg.sender != owner()) {
            require(msg.value >= Storage.presaleprice, "Invalid Amount");
        }
        tokenIdCounter++;
        updateNFTDetails(tokenIdCounter);
    }

    function updateNFTDetails(uint256 tokenId) internal {
        Storage.TokenMetaData storage nft = Storage._nftDetails[tokenId];
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

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721)
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
        Storage.TokenMetaData memory nft = Storage._nftDetails[tokenId];
        NFTData memory nftData;

        // Reading From Map
        nftData.background = Storage.backgroundMap[
            nft.currentDetails.Background.value
        ]; // -0.102 kb
        nftData.hat = Storage.hatMap[nft.currentDetails.Hat.value];
        nftData.jacket = Storage.jacketMap[nft.currentDetails.Jacket.value];
        nftData.hair = Storage.hairMap[nft.currentDetails.Hair.value];
        nftData.nose = Storage.noseMap[nft.currentDetails.Nose.value];
        nftData.glass = Storage.glassMap[nft.currentDetails.Glass.value];
        nftData.ear = Storage.earMap[nft.currentDetails.Ear.value];

        // Reading From Array
        // nftData.background = Storage.Background[nft.currentDetails.Background.value-1]; // 0.102 kb

        // string memory name = string(abi.encodePacked("Knowlytes #",tokenId.toString()));
        // string memory name = string(abi.encodePacked(("Knowlytes #1",tokenId.toString()));

        // nftData.imageURI = string(abi.encodePacked(Storage.baseURI,tokenId.toString(),".gif"));
        // nftData.background = Storage.Background[nft.currentDetails.Background.value-1];
        // nftData.hat = Storage.Hat[nft.currentDetails.Hat.value-1];
        // nftData.jacket = Storage.Jacket[nft.currentDetails.Jacket.value-1];
        // nftData.hair = Storage.Hair[nft.currentDetails.Hair.value-1];
        // nftData.nose = Storage.Nose[nft.currentDetails.Nose.value-1];
        // nftData.glass  = Storage.Glass[nft.currentDetails.Glass.value-1];
        // nftData.ear = Storage.Ear[nft.currentDetails.Ear.value-1];

        if (Storage.isRevealed) {
            (bool success, bytes memory data) = helperAddress.staticcall(
                abi.encodeWithSignature(
                    "getTokenURI(uint256,nftData)",
                    tokenId,
                    Storage.baseURI,
                    nftData
                )
            );
            require(success, "Tx Failed");
            string memory uri = string(data);
            return uri;
        }

        return Storage.revealURI;
    }

    //Toggle Functions
    function toggleMinting() external onlyOwner {
        Storage.isMintingPaused = !Storage.isMintingPaused;
    }

    function toggleReveal() external onlyOwner {
        Storage.isRevealed = !Storage.isRevealed;
    }

    function setManager(address _manager) external onlyOwner {
            Storage.manager = _manager;
    }

    function toggleWhiteListMinting() external onlyOwner {
        Storage.isWhiteListedPaused = !Storage.isWhiteListedPaused;
    }

    function setPrice(uint256 _newPrice) external onlyOwner {
        Storage.price = _newPrice;
    }

    function setBaseURI(string calldata _newURI) external onlyOwner {
        Storage.baseURI = _newURI;
    }

    function setRevealURI(string calldata _newURI) external onlyOwner {
        Storage.revealURI = _newURI;
    }

    function updateTraitCounter(
        uint8 hat,
        uint8 jacket,
        uint8 hair,
        uint8 nose,
        uint8 glass,
        uint8 ear
    ) private {
        Storage.traitCounter[1][hat] += 1;
        Storage.traitCounter[2][jacket] += 1;
        Storage.traitCounter[3][hair] += 1;
        Storage.traitCounter[4][nose] += 1;
        Storage.traitCounter[5][glass] += 1;
        Storage.traitCounter[6][ear] += 1;
    }

    function changeTraits(
        uint256 _tokenId,
        uint8 _type,
        uint8 _value
    ) external {
        require(ownerOf(_tokenId) == msg.sender, "Not Hold TokenId");
        (bool success, ) = helperAddress.delegatecall(
            abi.encodeWithSignature(
                "changeTrait(uint256,uint8,uint8)",
                _tokenId,
                _type,
                _value
            )
        );
        require(success, "Tx Failed");
    }

    function generateRandom(address _account, uint256 range)
        private
        view
        returns (uint256)
    {
        uint256 startToken = 0;
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.timestamp,
                        _account,
                        block.difficulty,
                        startToken
                    )
                )
            ) % range;
    }
}
