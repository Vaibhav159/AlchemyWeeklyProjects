//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

// Deployed to Goerli at this address -> 0x3495ef29933b63085bDDD73968970eA384c96762

import "hardhat/console.sol";

contract BuyMeACoffee {
    // Event to emit when a memo is added
    event NewMemo(
        address indexed sender,
        uint256 timestamp,
        string name,
        string message
    );

    // Memo Struct
    struct Memo {
        address sender;
        uint256 timestamp;
        string name;
        string message;
    }

    // List of Memos received so far
    Memo[] memos;

    // Address of the contract owner
    address payable owner;

    // Address allowed to withdraw funds from the contract.
    address payable withdrawAddress;

    // Constructor to set the owner
    constructor() {
        owner = payable(msg.sender);
        withdrawAddress = payable(msg.sender);
    }

    function pushAndEmitMemo(string memory _name, string memory _message) private {
        // Create a new memo and push to memos list.
        memos.push(
            Memo(
                msg.sender,
                block.timestamp,
                _name,
                _message
            )
        );
        
        emit NewMemo(msg.sender, block.timestamp, _name, _message);
    }

    /**
        * @dev Add to buy a coffee for the contract owner.
        * @param _name The name of the person who bought the coffee
        * @param _message The message to send to the owner
     */
    function buyCoffee(string memory _name, string memory _message) public payable {
        // Check if value is greater than 0.001 ether
        require(msg.value >= 10**15, "Can't buy a coffee for less than 0.001 ETH");
        
        pushAndEmitMemo(_name, _message);
    }


    /**
        * @dev Add to buy large coffee for the contract owner.
        * @param _name The name of the person who bought the coffee
        * @param _message The message to send to the owner
     */
    function buyLargeCoffee(string memory _name, string memory _message) public payable {
        // Check if value is greater than 0.003 ether
        require(msg.value >= 3*(10**15), "Can't buy a coffee for less than 0.003 ETH");

        pushAndEmitMemo(_name, _message);
    }

    /**
        * @dev Send tips to contract owner.
    */
    function withdrawTipsFromContractToOwner() public{
        // Check if the contract owner is the msg.sender
        require(msg.sender == withdrawAddress, "Only the address allowed to withdraw funds from the contract can do this.");

        // Get the total amount stored in the contract
        uint256 balanceInTheContract = address(this).balance;

        // Check if the contract owner has any tips
        require(balanceInTheContract > 0, "The contract has no tips to withdraw");

        // Send the tips to the contract owner
        require(withdrawAddress.send(balanceInTheContract), "Could not send tips to the user.");
    }

    /**
        * @dev Returns all memos stores on blockchain
    */
    function getMemos() public view returns(Memo[] memory) {
        return memos;
    }

    /**
        * @dev Owner can change the withdrawal address of the contract.
    */
    function setWithdrawAddress(address payable _withdrawAddress) public {
        require(msg.sender == owner, "Only the contract owner can change the withdrawal address");
        withdrawAddress = _withdrawAddress;
    }

}
