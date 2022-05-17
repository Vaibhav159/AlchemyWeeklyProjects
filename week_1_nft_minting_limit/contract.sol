// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.6.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.6.0/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts@4.6.0/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.6.0/utils/Counters.sol";

contract Python is ERC721, ERC721Enumerable, ERC721URIStorage {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    mapping(address => uint256) private nft_minted_by_person;
    uint256 MAX_SUPPLY_OF_FIREBALL = 1000;
    uint256 MAX_FIREBALL_PER_USER = 5;

    constructor() ERC721("Fireball", "FRB") {}

    function permissionToMintMore(address payable minterAddress) private {
        uint256 current_nft_count_of_user = nft_minted_by_person[minterAddress];
        require(current_nft_count_of_user < MAX_FIREBALL_PER_USER, "Sorry no more fireballs for you.");
        nft_minted_by_person[minterAddress] += 1;
    }

    function safeMint(address to, string memory uri) public {
        permissionToMintMore(payable(to));
        uint256 tokenId = _tokenIdCounter.current();
        require(tokenId <= MAX_SUPPLY_OF_FIREBALL, "No FireBall left to mint, please try again when new supply is added.");
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

}
