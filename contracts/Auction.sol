// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

interface IERC721 {
    function transfer(address, uint) external;
    function transferFrom(
        address,
        address,
        uint
        ) external;
}

contract Auction {
    event Start();
    event End(address highestBidder, uint highestBid);
    event Bid(address indexed sender, uint amount);
    event Withdraw(address indexed bidder, uint amount);
    event Cancel();

    address payable public seller;

    bool public started;
    bool public ended;
    uint public endAt;

    IERC721 public nft;
    uint public nftId;

    uint public highestBid;
    address public highestBidder;
    mapping(address => uint) public bids;

    constructor() {
        seller = payable(msg.sender);
    }
    /**
     * starting auction 
     * @param IERC721 _nft address
     * @param uint _nftID unique id
     * @param uint _startingBid price
     * @param uint _biddingTime timestamp  
     * 
     */
    function startAuction(IERC721 _nft, uint _nftId, uint _startingBid, uint _biddingTime) external {
        require(!started, "already started!");
        require(msg.sender == seller, "you did not start the auction!");
        
        highestBid = _startingBid;

        nft = _nft;
        nftId = _nftId;
        nft.transferFrom(msg.sender, address(this), nftId);

        started = true;

        endAt = block.timestamp + _biddingTime;

        emit Start();
    }

/**
 * add bit from msg.sender
 */
    function bid() external payable {
        require(started, "not started.");
        require(block.timestamp < endAt, "ended!");
        require(msg.value > highestBid);

        if (highestBidder != address(0)) {
            bids[highestBidder] += highestBid;
        }

        highestBid = msg.value;
        highestBidder = msg.sender;

        emit Bid(highestBidder, highestBid);

    }

    /**
     * withdraw bid
     */
    function withdraw() external payable {
        uint bal = bids[msg.sender];
        bids[msg.sender] = 0;
        (bool sent, bytes memory data) = payable(msg.sender).call{value: bal}("");
        require(sent, "could not withdraw!");

        emit Withdraw(msg.sender, bal);
    }
    /**
     * end auction 
     * send nft to highest bid or return the NFT to owner
     */
    function endAuction() external {
        require(started, "you need to start first");
        require(block.timestamp >= endAt, "auction is still ongoing!");
        require(!ended, "auction already ended!");

        if (highestBidder != address(0)) {
            nft.transfer(highestBidder, nftId);
            (bool sent, bytes memory data) = payable(msg.sender).call{value: highestBid}("");
            require(sent, "could not pay seller!");
        } else {
            nft.transfer(seller, nftId);
        }

        ended = true;
        emit End(highestBidder, highestBid);
    }

    /**
     * canceling aunction before the end 
     */
    function cancelAuction() external {
        require(block.timestamp <= endAt, "the auction finished!");
        require(seller != msg.sender, "you are not owner or approved!");

        nft.transfer(seller, nftId);
        ended = true;
        started = false;
        emit Cancel();
    }
}