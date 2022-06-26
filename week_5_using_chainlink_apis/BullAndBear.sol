// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.8/KeeperCompatible.sol";

import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

// contract address -> 0x74A8AEd6402bAF851B39cA33dD0373921e516516

contract BullAndBear is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable, KeeperCompatibleInterface, VRFConsumerBaseV2 {
    VRFCoordinatorV2Interface COORDINATOR;

    // Map of request IDs to the corresponding sender.
    mapping(uint256 => address) public requestIdToSender;

    // Map of request IDs to the corresponding random number.
    mapping(uint256 => uint256) public requestIdToRandomNumber;

    // constant
    uint256 public constant RANDOM_RANGE = 4;

    // Your subscription ID.
    uint64 s_subscriptionId;

    // Rinkeby coordinator. For other networks,
    // see https://docs.chain.link/docs/vrf-contracts/#configurations
    address vrfCoordinator = 0x6168499c0cFfCaCD319c818142124B7A15E857ab;

    // The gas lane to use, which specifies the maximum gas price to bump to.
    // For a list of available gas lanes on each network,
    // see https://docs.chain.link/docs/vrf-contracts/#configurations
    bytes32 keyHash = 0xd89b2bf150e3b9e13446986e571fb9cab24b13cea0a43ea20a6049a85cc807cc;

    // Depends on the number of requested values that you want sent to the
    // fulfillRandomWords() function. Storing each word costs about 20,000 gas,
    // so 100,000 is a safe default for this example contract. Test and adjust
    // this limit based on the network that you select, the size of the request,
    // and the processing of the callback request in the fulfillRandomWords()
    // function.
    uint32 callbackGasLimit = 100000;

    // The default is 3, but you can set this higher.
    uint16 requestConfirmations = 3;

    // For this example, retrieve 2 random values in one request.
    // Cannot exceed VRFCoordinatorV2.MAX_NUM_WORDS.
    uint32 numWords =  1;

    uint256[] public s_randomWords;
    uint256 public s_requestId;
    address s_owner;

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

    constructor(uint updateInterval, address _priceFeed, uint64 subscriptionId) ERC721("BullAndBear", "BAB") VRFConsumerBaseV2(vrfCoordinator) {
        interval = updateInterval;
        lastTimestamp = block.timestamp;

        // set the price feed address to
        // BTC/USD Price Feed Contract Address on Rinkeby: https://rinkeby.etherscan.io/address/0xECe365B379E1dD183B20fc5f022230C044d51404
        // or the MockPriceFeed Contract
        priceFeed = AggregatorV3Interface(_priceFeed);
        currentPrice = getLatestPrice();

        COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
        s_owner = msg.sender;
        s_subscriptionId = subscriptionId;
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
        uint256 randon_number = getRandomNumber();

        if (compareStrings("bear", trend)){
            newTrendUri = bearUrisIpfs[randon_number];
        }
        else{
            newTrendUri = bullUrisIpfs[randon_number];
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

      // Assumes the subscription is funded sufficiently.
    function requestRandomWords() internal onlyOwner returns (uint256) {
        // Will revert if subscription is not set and funded.
        s_requestId = COORDINATOR.requestRandomWords(
        keyHash,
        s_subscriptionId,
        requestConfirmations,
        callbackGasLimit,
        numWords
        );

        requestIdToSender[s_requestId] = msg.sender;

        return s_requestId;
    }
    
    function fulfillRandomWords(
        uint256 requestId,
        uint256[] memory randomWords
    ) internal override {
        s_randomWords = randomWords;
        requestIdToRandomNumber[requestId] = (randomWords[0] % RANDOM_RANGE);
    }
    

    // Request random words from the VRF coordinator and get the random number.
    function getRandomNumber() internal returns (uint256) {
        uint256 requestId = requestRandomWords();
        uint256 randomNumber = requestIdToRandomNumber[requestId];
        return randomNumber;
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