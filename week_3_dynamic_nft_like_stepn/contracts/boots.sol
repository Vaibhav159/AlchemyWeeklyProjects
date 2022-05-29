// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// contract address : 0x1a8F983Bc3Bc93c5F77bfEDbb16feDd74F0dD293

// import libraries like ERC21URIStorage, Counters, Base64 and Strings
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";


// Define the contract
contract bootsForLife is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;

    // Define the variables
    Counters.Counter private _tokenIds;
    mapping(uint256 => uint256) private _tokenIdsToLevels;

    // Constructor  
    constructor() ERC721("Boots for Life", "BFL") {   
    }

    // Define the functions
    function generateBoot(uint256 tokenId) public view returns(string memory){
        bytes memory svg = abi.encodePacked(
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
        '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
        '<rect width="100%" height="100%" fill="black" />',
        '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',"Boot",'</text>',
        '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Levels: ",getLevels(tokenId),'</text>',
        '</svg>'
        );
        return string(
            abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(svg)
            )
        );
    }

    function getLevels(uint256 tokenId) public view returns(string memory){
        uint256 levels = _tokenIdsToLevels[tokenId];
        return levels.toString();
    }

    function getTokenURI(uint256 tokenId) public view returns(string memory){
        bytes memory dataURI = abi.encodePacked(
            '{',
            '"name": "Chain Battles #', tokenId.toString(), '",',
            '"description": "Battles on chain",',
            '"image": "', generateBoot(tokenId), '"',
            '}'
        );

        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            )
        );
    }

    function mint() public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        _tokenIdsToLevels[newItemId] = 0;
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    function upgrade(uint256 tokenId) public {
        require(_exists(tokenId), "Token does not exist.");
        require(msg.sender == ownerOf(tokenId), "Only owner can upgrade the boot.");
        _tokenIdsToLevels[tokenId]++;
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }
}
