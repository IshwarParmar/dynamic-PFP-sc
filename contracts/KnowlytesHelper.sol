// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./BokkyPooBahsDateTimeLibrary.sol";
import "./Storage.sol";

contract KnowlytesHelper is Storage{
    using Strings for uint256;
    using BokkyPooBahsDateTimeLibrary for uint256;


        
    function getTokenURI(uint256 tokenId,string memory baseURI,NFTData memory data) external pure returns(string memory){
        string memory name = string(abi.encodePacked("Knowlytes #",tokenId.toString()));
        string memory imageURI = string(abi.encodePacked(baseURI,tokenId.toString(),'.gif'));
            return string(
                abi.encodePacked(
                    'data:application/json;base64,',
                    Base64.encode(
                        bytes(
                            abi.encodePacked('{"name":"', name, '", "description":"Knowledge is Power", "image": "',imageURI,'", "attributes": [{"trait_type": "Background", "value": "',data.background,'" },{"trait_type": "Body", "value": "Body" }, {"trait_type": "Hat", "value": "',data.hat, '" },{"trait_type": "Jacket", "value": "',data.jacket, '" },{"trait_type": "Hair", "value": "',data.hair, '" },{"trait_type": "Nose", "value": "',data.nose,'" },{"trait_type": "Glass", "value": "',data.glass, '" },{"trait_type": "Ear", "value": "',data.ear,'" }] }')
                        )
                    )
                )
            );
    }

    function isEligibleToWhiteListMint(uint256 tokenId,bytes32[] calldata proof) external view returns(bool){
        require(isValid(proof, keccak256(abi.encodePacked(msg.sender))), "Not Allowed");
        require(Storage.isWhiteListedPaused,"WhiteList Mint Paused");
        require(tokenId<=Storage.maxSupply,"All NFT Minted!");
        return true;
    }

    function changeTrait(uint256 tokenId,uint8 _type,uint8 _value) external {
        require(_type>=1 && _type<=6,"Invalid Type");
        require(_value>=1 && _value <=14,"Invalid Value");  
        Storage.TokenMetaData storage nft = Storage._nftDetails[tokenId];    
        uint256 currentMonth = BokkyPooBahsDateTimeLibrary.getMonth(block.timestamp);
        require(currentMonth!=nft.changedMonth,"Already Changed For This Month");
        nft.haveChanged = true;
        bool flag;

        if(_type ==1 && _value <=14){
            require(!nft.currentDetails.Hat.isFreezed,"Can't Change Hat Disable For You");
            require(hatFreezedMap[_value],"Head Trait Value Freezed");
            nft.selectedDetails.Hat.value = _value;
            flag = true;
        }
        if(_type == 2 && _value <=14){
            require(!nft.currentDetails.Jacket.isFreezed,"Can't Change Jacket Disable for You");
            require(jacketFreezedMap[_value],"Jacket Trait Value Freezed");
            nft.selectedDetails.Jacket.value = _value;
            flag = true;
        }
        if(_type == 3 && _value <=13){
            require(!nft.currentDetails.Hair.isFreezed,"Can't Change Hair Disable for You");
            require(hairFreezedMap[_value],"Hair Trait Value Freezed");
             nft.selectedDetails.Hair.value = _value;
             flag = true;
        }
        if(_type == 4 && _value <=8){
            require(!nft.currentDetails.Nose.isFreezed,"Can't Change Nose Disable for You");
            require(noseFreezedMap[_value],"Nose Trait Value Freezed");
             nft.selectedDetails.Nose.value = _value;
             flag = true;
        }
        if(_type ==5 && _value <=8){
            require(!nft.currentDetails.Glass.isFreezed,"Can't Change Glass Disable for You");
            require(glassFreezedMap[_value],"Glass Trait Value Freezed");
              nft.selectedDetails.Glass.value = _value;
              flag = true;
        }
        if(_type ==6 && _value <=8){
            require(!nft.currentDetails.Ear.isFreezed,"Can't Change Ear Disable for You");
            require(earFreezedMap[_value],"Ear Trait Value Freezed");
             nft.selectedDetails.Ear.value = _value;
             flag = true;
        }

        if(!flag){revert("Invalid Input");}
    }

    // function withdraw() external payable onlyOwner {
    //         ( bool success,) = payable(owner()).call{value:address(this).balance}("");
    //         require(success,"Tx Failed");
    // }


    function freezeTraitVal() public {
        /*
         we want to freeze the values which has less than 5% count

        Calculating 5%
          count*100/1111 > 5;
          count > 5*1111/100;
          count > 55.55 or 56;
        */
        require(msg.sender == Storage.manager,"Only Manager");
        uint256 _totalCount = Storage.tokenIdCounter;
        for (uint256 i = 1; i<=_totalCount; i++){
            if(Storage.traitCounter[1][Storage._nftDetails[i].currentDetails.Hat.value] < 56){
               Storage._nftDetails[i].currentDetails.Hat.isFreezed = true;
            }
            if(Storage.traitCounter[1][Storage._nftDetails[i].currentDetails.Jacket.value] < 56){
               Storage._nftDetails[i].currentDetails.Jacket.isFreezed = true;
            }
            if(Storage.traitCounter[1][Storage._nftDetails[i].currentDetails.Hair.value] < 56){
               Storage._nftDetails[i].currentDetails.Hair.isFreezed = true;
            }
            if(Storage.traitCounter[1][Storage._nftDetails[i].currentDetails.Nose.value] < 56){
               Storage._nftDetails[i].currentDetails.Nose.isFreezed = true;
            }
            if(Storage.traitCounter[1][Storage._nftDetails[i].currentDetails.Glass.value] < 56){
               Storage._nftDetails[i].currentDetails.Glass.isFreezed = true;
            }
            if(Storage.traitCounter[1][Storage._nftDetails[i].currentDetails.Ear.value] < 56){
               Storage._nftDetails[i].currentDetails.Ear.isFreezed = true;
            }
        }
    }
    
    //Function for freezing all the rare values
    function freezeRareValues() public {
        for(uint8 i=1; i<=14; i++ ){
            if(Storage.traitCounter[1][i] < 56){
                Storage.hatFreezedMap[i] = true;
            }
            if(Storage.traitCounter[2][i] < 56){
                Storage.jacketFreezedMap[i] = true;
            }
            if(Storage.traitCounter[3][i] < 56 && i < 14){
                Storage.hairFreezedMap[i] = true;
            }
            if(Storage.traitCounter[4][i] < 56 && i < 9){
                Storage.noseFreezedMap[i] = true;
            }
            if(Storage.traitCounter[5][i] < 56 && i < 9){
                Storage.glassFreezedMap[i] = true;
            }
            if(Storage.traitCounter[6][i] < 56 && i < 9){
                Storage.earFreezedMap[i] = true;
            }     
        }
    }
    function isValid(bytes32[] calldata proof, bytes32 leaf) internal view returns (bool) {
        return MerkleProof.verify(proof, Storage.rootHash, leaf);
    }
}

