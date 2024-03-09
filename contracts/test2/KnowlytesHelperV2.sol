// SPDX-License-Identifier: UNLICENSED
 pragma solidity 0.8.4;
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./BokkyPooBahsDateTimeLibraryV2.sol";
import "./StorageV2.sol";


 contract KnowlytesHelperV2 is StorageV2{
     using Strings for uint256;
     using BokkyPooBahsDateTimeLibraryV2 for uint256;

    // Function Allow to Change Any Trait Once in A Month
    function changeTrait(uint256 tokenId,bytes32 data) external {
        StorageV2.TokenMetaData storage nft = StorageV2.nftDetails[tokenId];
        uint256 currentMonth = BokkyPooBahsDateTimeLibraryV2.getMonth(block.timestamp);
        require(currentMonth!=nft.changedMonth,"Already Changed For This Month");
        nft.haveChanged = true;
        nft.hashedProof = data;
        nft.changedMonth = currentMonth;
        emit StorageV2.ChangeTrait(tokenId,data);
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

    function isWhiteListedAddress(bytes32[] calldata proof) external view {
        require(isValid(proof,keccak256(abi.encodePacked(msg.sender))),"Not WhiteListed Address");
    }

    function isValid(bytes32[] calldata proof, bytes32 leaf) internal view returns (bool) {
        return MerkleProof.verify(proof, StorageV2.rootHash, leaf);
    }

    function freezeValues(uint8[][6] calldata min, uint256[][6] calldata totalId) external{
        require(msg.sender == StorageV2.manager,"Only Manager");
        for(uint8 i =0; i<min[0].length; i++){
            StorageV2.hatFreezedMap[min[0][i]] = true;
        }
        for(uint8 i =0; i<min[1].length; i++){
            StorageV2.jacketFreezedMap[min[1][i]] = true;
        }
        for(uint8 i =0; i<min[2].length; i++){
            StorageV2.hairFreezedMap[min[2][i]] = true;
        }
        for(uint8 i =0; i<min[3].length; i++){
            StorageV2.noseFreezedMap[min[3][i]] = true;
        }
        for(uint8 i =0; i<min[4].length; i++){
            StorageV2.glassFreezedMap[min[4][i]] = true;
        }
        for(uint8 i =0; i<min[5].length; i++){
            StorageV2.earFreezedMap[min[5][i]] = true;
        }
        freezeTokenID(totalId);
    }
    // Function that freezes tokenids having rare values
    function freezeTokenID(uint256[][6] calldata totalId) internal{
        for(uint256 i =0; i<totalId[0].length; i++){
            StorageV2.nftDetails[totalId[0][i]].currentDetails.Hat.isFreezed = true;
        }
        for(uint256 i =0; i<totalId[1].length; i++){
            StorageV2.nftDetails[totalId[1][i]].currentDetails.Jacket.isFreezed = true;
        }
        for(uint256 i =0; i<totalId[2].length; i++){
            StorageV2.nftDetails[totalId[2][i]].currentDetails.Hair.isFreezed = true;
        }
        for(uint256 i =0; i<totalId[3].length; i++){
            StorageV2.nftDetails[totalId[3][i]].currentDetails.Nose.isFreezed = true;
        }
        for(uint256 i =0; i<totalId[4].length; i++){
            StorageV2.nftDetails[totalId[4][i]].currentDetails.Glass.isFreezed = true;
        }
        for(uint256 i =0; i<totalId[5].length; i++){
            StorageV2.nftDetails[totalId[5][i]].currentDetails.Ear.isFreezed = true;
        }
    } 

 }