 // SPDX-License-Identifier: MIT
 pragma solidity 0.8.4;
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./BokkyPooBahsDateTimeLibraryV1.sol";
import "./StorageV1.sol";
 
 contract KnowlytesV1Helper is StorageV1{
    using Strings for uint256;
    using BokkyPooBahsDateTimeLibraryV1 for uint256;


    // Function Allow to Change Any Trait Once in A Month
    function changeTrait(uint256 tokenId,bytes32 data) external {
        StorageV1.TokenMetaData storage nft = StorageV1.nftDetails[tokenId];
        uint256 currentMonth = BokkyPooBahsDateTimeLibraryV1.getMonth(block.timestamp);
        require(currentMonth!=nft.changedMonth,"Already Changed For This Month");
        nft.haveChanged = true;
        nft.hashedProof = data;
        nft.changedMonth = currentMonth;
        emit StorageV1.ChangeTrait(tokenId,data);
    }
    

    function isWhiteListedAddress(bytes32[] calldata proof) external view{
        require(isValid(proof,keccak256(abi.encodePacked(msg.sender))),"Not WhiteListed Address");
    }
    
    function isValid(bytes32[] calldata proof, bytes32 leaf) internal view returns (bool) {
        return MerkleProof.verify(proof, StorageV1.rootHash, leaf);
    } 

    //Function Will Create Base64 Based String Based On Param and Return It
    function getTokenURI(uint256 tokenId,string memory baseURI,NFTData memory data) external pure returns(string memory){
        string memory name = string(abi.encodePacked("Knowlytes #",tokenId.toString()));
        string memory imageURI = string(abi.encodePacked(baseURI,tokenId.toString(),'.gif'));
        string memory URI =  string(
                abi.encodePacked(
                    'data:application/json;base64,',
                    Base64.encode(
                        bytes(
                            abi.encodePacked('{"name":"', name, '", "description":"Knowledge is Power", "image": "',imageURI,'", "attributes": [{"trait_type": "Background", "value": "',data.background,'" },{"trait_type": "Body", "value": "Body" }, {"trait_type": "Hat", "value": "',data.hat, '" },{"trait_type": "Jacket", "value": "',data.jacket, '" },{"trait_type": "Hair", "value": "',data.hair, '" },{"trait_type": "Nose", "value": "',data.nose,'" },{"trait_type": "Glass", "value": "',data.glass, '" },{"trait_type": "Ear", "value": "',data.ear,'" }] }')
                        )
                    )
                )
            );
            return URI;
    }

    function freezeValues(uint8[][6] calldata min, uint256[][6] calldata totalId) external{
        require(msg.sender == StorageV1.manager,"Only Manager");
        require(min[0].length == 6,"Invalid Input" );
        for(uint8 i =0; i<min[0].length; i++){
            StorageV1.hatFreezedMap[min[0][i]] = true;
        }
        for(uint8 i =0; i<min[1].length; i++){
            StorageV1.jacketFreezedMap[min[1][i]] = true;
        }
        for(uint8 i =0; i<min[2].length; i++){
            StorageV1.hairFreezedMap[min[2][i]] = true;
        }
        for(uint8 i =0; i<min[3].length; i++){
            StorageV1.noseFreezedMap[min[3][i]] = true;
        }
        for(uint8 i =0; i<min[4].length; i++){
            StorageV1.glassFreezedMap[min[4][i]] = true;
        }
        for(uint8 i =0; i<min[5].length; i++){
            StorageV1.earFreezedMap[min[5][i]] = true;
        }
        freezeTokenID(totalId);
    }

    // Function that freezes tokenids having rare values
    function freezeTokenID(uint256[][6] calldata totalId) internal{
        require(msg.sender == StorageV1.manager, "Only Manager can freeze");
        for(uint256 i =0; i<totalId[0].length; i++){
            StorageV1.nftDetails[i+1].currentDetails.Hat.isFreezed = true;
        }
        for(uint256 i =0; i<totalId[1].length; i++){
            StorageV1.nftDetails[i+1].currentDetails.Jacket.isFreezed = true;
        }
        for(uint256 i =0; i<totalId[2].length; i++){
            StorageV1.nftDetails[i+1].currentDetails.Hair.isFreezed = true;
        }
        for(uint256 i =0; i<totalId[3].length; i++){
            StorageV1.nftDetails[i+1].currentDetails.Nose.isFreezed = true;
        }
        for(uint256 i =0; i<totalId[4].length; i++){
            StorageV1.nftDetails[i+1].currentDetails.Glass.isFreezed = true;
        }
        for(uint256 i =0; i<totalId[5].length; i++){
            StorageV1.nftDetails[i+1].currentDetails.Ear.isFreezed = true;
        }
    }

 }