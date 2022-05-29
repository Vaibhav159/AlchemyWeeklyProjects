// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// contract address : 0xE84DC1CE003b03B441dD91117fB363ba0BdE2Ca8

// import libraries like ERC21URIStorage, Counters, Base64 and Strings
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";


// Define the contract
contract bootsForLife is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;

    struct Boot{
        uint256 level;
        uint256 efficiency;
        uint256 luck;
        uint256 comfort;
        uint256 resilience;
    }
    
    // Define the variables
    Counters.Counter private _tokenIds;
    mapping(uint256 => Boot) public _tokenIdsToBoot;
    uint256 private MAX_LEVEL_ALLOWED_PER_BOOT = 30;
    uint256 private RANDOM_ATTRIBUTE_MOD = 5;

    // Constructor  
    constructor() ERC721("Boots for Life", "BFL") {   
    }


    // Define the functions
    function generateBootURI(uint256 tokenId) public view returns(string memory){
        (uint256 level, uint256 efficiency, uint256 luck, uint256 comfort, uint256 resilience) = getAttributes(tokenId);
        bytes memory svg = abi.encodePacked(
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
        '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
        '<rect width="100%" height="100%" fill="black" />',
        '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',"Boot",'</text>',
        '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Levels: ",level.toString(),'</text>',
        '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">', "Efficiency: ",efficiency.toString(),'</text>',
        '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">', "Luck: ",luck.toString(),'</text>',
        '<text x="50%" y="80%" class="base" dominant-baseline="middle" text-anchor="middle">', "Comfort: ",comfort.toString(),'</text>',
        '<text x="50%" y="90%" class="base" dominant-baseline="middle" text-anchor="middle">', "Resilience: ",resilience.toString(),'</text>',
        '</svg>'
        );
        return string(
            abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(svg)
            )
        );
    }

    function getAttributes(uint256 tokenId) public view returns(uint256, uint256, uint256, uint256, uint256){
        Boot memory boot = _tokenIdsToBoot[tokenId];
        return (boot.level, boot.efficiency, boot.luck, boot.comfort, boot.resilience);
    }

    function getTokenURI(uint256 tokenId) public view returns(string memory){
        bytes memory dataURI = abi.encodePacked(
            '{',
            '"name": "Boot #', tokenId.toString(), '",',
            '"description": "Boots for life",',
            '"image": "', generateBootURI(tokenId), '"',
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
        _tokenIdsToBoot[newItemId] = Boot(0,0,0,0,0);
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    function upgrade(uint256 tokenId) public {
        require(_exists(tokenId), "Token does not exist.");
        require(msg.sender == ownerOf(tokenId), "Only owner can upgrade the boot.");

        Boot storage boot = _tokenIdsToBoot[tokenId];
        // require(boot.level < MAX_LEVEL_ALLOWED_PER_BOOT, "You have reached the maximum level allowed per boot.");

        boot.level++;
        // Pseudo-randomly upgrade the attributes
        boot.efficiency = boot.efficiency + randomAttributeIncreaseBy(RANDOM_ATTRIBUTE_MOD);
        boot.luck = boot.luck + randomAttributeIncreaseBy(RANDOM_ATTRIBUTE_MOD);
        boot.comfort = boot.comfort + randomAttributeIncreaseBy(RANDOM_ATTRIBUTE_MOD);
        boot.resilience = boot.resilience + randomAttributeIncreaseBy(RANDOM_ATTRIBUTE_MOD);


        _setTokenURI(tokenId, getTokenURI(tokenId));
    }

    function randomAttributeIncreaseBy(uint256 mod) private view returns(uint256){
        uint attributeIncreaseBy = uint(
            keccak256(abi.encodePacked(msg.sender, block.timestamp, block.difficulty, block.number))
        ) % mod;

        return attributeIncreaseBy;
    }
}
