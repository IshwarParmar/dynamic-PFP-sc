// SPDX-License-Identifier:UNLICENSED

pragma solidity 0.8.4;

contract StorageV2{
    
    //Intergers
    uint256 public tokenIdCounter;
    uint256 internal price = 0.0000005 ether;
    uint256 internal preSalePrice = 0.0000004 ether;


    //Bytes32
    bytes32 internal rootHash;


    //Address
    address internal owner;
    address internal manager;
    address internal helper;

    //Constant 
    uint256 public constant maxSupply = 1111;


    //Booleans
    bool internal isMintingPaused;
    bool internal isWhiteListedPaused;
    bool internal isRevealed;


    //Strings
    string internal baseURI = "";
    string internal revealURI = "";


    //Events
    event MintKnowlytes(uint256 indexed tokenId,uint8 bg,uint8 hat,uint8 jacket,uint8 hair,uint8 nose,uint8 glass,uint8 ear);
    event ChangeTrait(uint256 indexed tokenId,bytes32 indexed data);

    //Modifiers
    modifier onlyOwner{
        _onlyOwner();
        _;
    }


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
        bytes32 hashedProof;
        Traits currentDetails;
        bool haveChanged;
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

    //Mappings
    mapping(uint256 => string) internal hatMap;
    mapping(uint256 => string) internal jacketMap;
    mapping(uint256 => string) internal hairMap;
    mapping(uint256 => string) internal noseMap;
    mapping(uint256 => string) internal glassMap;
    mapping(uint256 => string) internal earMap;
    mapping(uint256 => string) internal backgroundMap;



    // Traits Freezed Mapping
    mapping(uint256 => bool) internal hatFreezedMap;
    mapping(uint256 => bool) internal jacketFreezedMap;
    mapping(uint256 => bool) internal hairFreezedMap;
    mapping(uint256 => bool) internal noseFreezedMap;
    mapping(uint256 => bool) internal glassFreezedMap;
    mapping(uint256 => bool) internal earFreezedMap;


    //Traits Details
    mapping(uint256 => TokenMetaData) internal nftDetails;
    mapping(uint8 => mapping(uint8 => uint256)) internal traitCounter;

    //Functions
    function _onlyOwner() private view{
        require(msg.sender == owner,"only Owner");
    }


}