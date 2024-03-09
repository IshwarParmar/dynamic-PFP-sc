 // SPDX-License-Identifier: MIT
 pragma solidity 0.8.4;
 contract StorageV1{

    address public manager;
    address public helper;

    //Integers
    uint256 public tokenIdCounter;
    uint256 public price = 0.000005 ether;
    uint256 public preSalePrice = 0.000004 ether;

    //Constant 
    uint256 public constant maxSupply = 1111;

    //Booleans
    bool public isMintingPaused;
    bool public isWhiteListedPaused;
    bool public isRevealed;

    //Bytes32
    bytes32 public rootHash;

    //Structs
    struct TraitValue{
        uint8 value;
        bool isFreezed;
    }
    struct Traits{
        TraitValue Hat;
        TraitValue Jacket;
        TraitValue Hair;
        TraitValue Nose;
        TraitValue Glass;
        TraitValue Ear;
        TraitValue Background;
    }
    struct TokenMetaData{
        uint256 tokenId;
        uint256 changedMonth;
        bool haveChanged;
        bytes32 hashedProof;
        Traits currentDetails;
    }

    struct NFTData{
        string background;
        string hat;
        string jacket;
        string hair;
        string nose;
        string glass;
        string ear;
    }

    //Strings
    string public baseURI = "";
    string public revealURI="";


    // Traits Mappings
    mapping(uint256 => string) public hatMap;
    mapping(uint256 => string) public jacketMap;
    mapping(uint256 => string) public hairMap;
    mapping(uint256 => string) public noseMap;
    mapping(uint256 => string) public glassMap;
    mapping(uint256 => string) public earMap;
    mapping(uint256 => string) public backgroundMap;


    //Traits Freezed Mapping
    mapping(uint8 => bool) public hatFreezedMap;
    mapping(uint8 => bool) public jacketFreezedMap;
    mapping(uint8 => bool) public hairFreezedMap;
    mapping(uint8 => bool) public noseFreezedMap;
    mapping(uint8 => bool) public glassFreezedMap;
    mapping(uint8 => bool) public earFreezedMap;


    //Traits Details
    mapping(uint256 => TokenMetaData) public nftDetails;
    mapping(uint8 => mapping(uint8 => uint256)) public traitCounter;


    //Events
     event MintKnowlytes(uint256 indexed tokenId,uint8 bg,uint8 hat,uint8 jacket,uint8 hair,uint8 nose,uint8 glass,uint8 ear);
     event ChangeTrait(uint256 indexed tokenId,bytes32 indexed data);
 }