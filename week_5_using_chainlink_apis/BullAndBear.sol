// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.8/KeeperCompatible.sol";


contract BullAndBear is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable, KeeperCompatibleInterface {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    uint public interval;
    uint public lastTimestamp;

    AggregatorV3Interface public priceFeed;
    int256 public currentPrice;

    string[] bullUrisIpfs = [
        "https://ipfs.filebase.io/ipfs/QmRXyfi3oNZCubDxiVFre3kLZ8XeGt6pQsnAQRZ7akhSNs",
        "https://ipfs.filebase.io/ipfs/QmRJVFeMrtYS2CUVUM2cHJpBV5aX2xurpnsfZxLTTQbiD3",
        "https://ipfs.filebase.io/ipfs/QmdcURmN1kEEtKgnbkVJJ8hrmsSWHpZvLkRgsKKoiWvW9g"
    ];

    string[] bearUrisIpfs = [
        "https://ipfs.filebase.io/ipfs/Qmdx9Hx7FCDZGExyjLR6vYcnutUR8KhBZBnZfAPHiUommN",
        "https://ipfs.filebase.io/ipfs/QmTVLyTSuiKGUEmb88BgXG3qNC8YgpHZiFbjHrXKH3QHEu",
        "https://ipfs.filebase.io/ipfs/QmbKhBXVWmwrYsTPFYfroR2N7NAekAMxHUVg2CWks7i9qj"
    ];

    event TokensUpdated(string marketTrend);

    constructor(uint updateInterval, address _priceFeed) ERC721("BullAndBear", "BAB") {
        interval = updateInterval;
        lastTimestamp = block.timestamp;

        // set the price feed address to
        // BTC/USD Price Feed Contract Address on Rinkeby: https://rinkeby.etherscan.io/address/0xECe365B379E1dD183B20fc5f022230C044d51404
        // or the MockPriceFeed Contract
        priceFeed = AggregatorV3Interface(_priceFeed);
        currentPrice = getLatestPrice();
    }

    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId); 

        // default to gamer bull uri.
        string memory defaultUri = bullUrisIpfs[0];
        _setTokenURI(tokenId, defaultUri);
    }

    // The following functions are overrides required by Solidity.

    function checkUpkeep(bytes calldata) external view override returns(bool upkeepNeeded, bytes memory){
        upkeepNeeded = (block.timestamp - lastTimestamp) > interval;
    }

    function performUpkeep(bytes calldata) external override{
        if ((block.timestamp - lastTimestamp) <= interval) {
            return;
        }
        
        lastTimestamp = block.timestamp;
        int lastestPrice = getLatestPrice();

        if (lastestPrice == currentPrice){
            return;
        }
        
        if (lastestPrice > currentPrice){
            updateAllTokenUris("bull");
        }
        else{
            updateAllTokenUris("bear");
        }

        currentPrice = lastestPrice;
    }
    

    function getLatestPrice() public view returns(int256){
        (
            /*uint80 roundID*/,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();

        //  example price returned 3034715771688
        return price;
    }

    function updateAllTokenUris(string memory trend) internal{

        string memory newTrendUri;
        if (compareStrings("bear", trend)){
            newTrendUri = bearUrisIpfs[1];
        }
        else{
            newTrendUri = bullUrisIpfs[1];
        }

        for(uint i=0;i<_tokenIdCounter.current();i++){
            _setTokenURI(i, newTrendUri);
        }

        emit TokensUpdated(trend);
    }

    // compare strings
    function compareStrings(string memory str1, string memory str2) internal pure returns (bool){
        return (keccak256(abi.encodePacked(str1)) == keccak256(abi.encodePacked(str2)));
    }

    function setInterval(uint256 newInterval) public onlyOwner{
        interval = newInterval;
    }

    function setPriceFeed(address newFeedAddress) public onlyOwner{
        priceFeed = AggregatorV3Interface(newFeedAddress);
    }

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