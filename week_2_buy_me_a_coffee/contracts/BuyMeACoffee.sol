//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

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

    // Constructor to set the owner
    constructor() {
        owner = payable(msg.sender);
    }

    /**
        * @dev Add to buy a coffee for the contract owner.
        * @param _name The name of the person who bought the coffee
        * @param _message The message to send to the owner
     */
    function buyCoffee(string memory _name, string memory _message) public payable {
        // Check if value is greater than 0.
        require(msg.value > 0, "Can't buy a coffee for 0 ETH");

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
        * @dev Send tips to contract owner.
    */
    function withdrawTipsFromContractToOwner() public{
        // Check if the contract owner is the msg.sender
        require(msg.sender == owner, "Only the contract owner can withdraw tips");

        // Get the total amount stored in the contract
        uint256 balanceInTheContract = address(this).balance;

        // Check if the contract owner has any tips
        require(balanceInTheContract > 0, "The contract owner has no tips to withdraw");

        // Send the tips to the contract owner
        require(owner.send(balanceInTheContract), "Could not send tips to the contract owner");

        // require(owner.send(address(this).balance));
    }

    /**
        * @dev Returns all memos stores on blockchain
    */
    function getMemos() public view returns(Memo[] memory) {
        return memos;
    }
}
