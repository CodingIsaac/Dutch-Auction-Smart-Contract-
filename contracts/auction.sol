// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract smartAuction {
    mapping(address => uint) bindingBids;
    uint public highestBidAmount;
    address public highestBidderAddress;
    uint public bidIncrements;
    string public ipfsHash;

    address public auctionOwner;

    enum auctionState {auctionStarted, auctionCurrentlyRunning, auctionCancelled, auctionCompleted}
    auctionState public state;

    receive() external payable {

    }

    fallback() external payable {

    }

    modifier validEntry() {
        require(msg.value >= 0.3 ether, "Insufficient Entry Amount");
        _;
    }

    modifier notOwner() {
        require(msg.sender != auctionOwner, "Owner cannot Participate in the Auction");
        _;
    }

    modifier onlyOwner() {
        require(auctionOwner == msg.sender, "You are not the Auction Owner");
        _;
    }


    constructor () {
        auctionOwner = payable (msg.sender);
        state = auctionState.auctionCurrentlyRunning;
        bidIncrements = 0.2 ether;
        ipfsHash = "";
    }

    

    function enterAuction() public payable notOwner validEntry{
      uint currentBindingBids =  bindingBids[msg.sender] + msg.value;
      require(currentBindingBids > highestBidAmount, "Highest Binding Bid is greater than your current Bid");
      bindingBids[msg.sender] = currentBindingBids;

    }

    function getAuctionBalance() public view returns (uint) {
        return address(this).balance;
    }

    

    function cancelAuction () public onlyOwner {
        state = auctionState.auctionCancelled;
    }

    function auctionComplete() public onlyOwner {
        state = auctionState.auctionCompleted;
    }

    function endAuction() public onlyOwner {
        
    }

    
}
