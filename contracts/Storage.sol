 // SPDX-License-Identifier: MIT
pragma solidity 0.8.4;
contract Storage{

        uint256 public tokenIdCounter;
        uint256 public price  = 0.000005 ether;
        uint256 public presaleprice = 0.00004 ether;

        //Constant
        uint16 public constant maxSupply = 1111;

        //Address
        address public  helperAddress;
        address public  manager; 

        //Booleans
        bool public isMintingPaused;
        bool public isWhiteListedPaused;
        bool public isRevealed;
    
        // Bytes32
        bytes32 public rootHash;

        //Structs
        struct TraitValue{
            uint8 value;
            bool isFreezed;
        }

        struct Trait{
            TraitValue Hat;
            TraitValue Jacket;
            TraitValue Hair;
            TraitValue Nose;
            TraitValue Glass;
            TraitValue Ear;
            TraitValue Background;
        }
        
        struct TokenMetaData{
            Trait currentDetails;
            Trait selectedDetails;
            bool haveChanged;
            uint256 changedMonth;
            uint256 tokenId;
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

        string public baseURI = 'http://3.110.231.144:5000/knowlyets/';
        string public revealURI = 'https://gateway.pinata.cloud/ipfs/QmRX8JPntUKEDgCXbqXoNLLKSe3jRapoDD9WPTs8B7qQB2';

        // Traits Mappings
        mapping(uint256 => string) public hatMap;
        mapping(uint256 => string) public jacketMap;
        mapping(uint256 => string) public hairMap;
        mapping(uint256 => string) public noseMap;
        mapping(uint256 => string) public glassMap;
        mapping(uint256 => string) public earMap;
        mapping(uint256 => string) public backgroundMap;

        // Traits Details
        mapping(uint8 => mapping(uint8 => Trait)) public _nftTraitMap;
        mapping (uint256=>TokenMetaData) public _nftDetails;
        mapping(uint8 => mapping(uint8 => uint256)) public traitCounter;


        //mapping(uint256 => TraitValue) public hatMap; -> This Apporach will add 4.7kb 
        // mapping(uint256 => bool) public hatMapFreezed;

        mapping(uint8 => bool) public hatFreezedMap;
        mapping(uint8 => bool) public jacketFreezedMap;
        mapping(uint8 => bool) public hairFreezedMap;
        mapping(uint8 => bool) public noseFreezedMap;
        mapping(uint8 => bool) public glassFreezedMap;
        mapping(uint8 => bool) public earFreezedMap;

        
}