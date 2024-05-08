// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract AuctionMarketplace is ERC721 {
    IERC20 public basicToken;
    IERC721 public Nft;

    using Counters for Counters.Counter;
    Counters.Counter public nftIds;
    address nftBidder;

    address nftWallet;

    struct Listing {
        address nftOwner;
        uint256 tokenId;
        uint256 price;
        bool isListed;
        uint256 endTime;
    }

    mapping(uint256 => Listing) public listings;
    mapping(uint256 => uint256) public highestBid;
    mapping(uint256 => address) public highestBidder;

    constructor() ERC721("NftMatketplace", "NFTM") {
        basicToken = IERC20(0x7C4e30a43ecC4d3231b5B07ed082329020D141F3);
        Nft = IERC721(0xCc3958FE4Beb3bcb894c184362486eBEc2E1fD4D);
    }

    //Listing NFT
    function AuctionNFT(
        uint256 id,
        uint256 minPrice,
        uint256 timeInSeconds
    ) public {
        require(minPrice > 0, "price should be higher than 0");
        require(timeInSeconds > 0, "time should be higher than 0");
        //min price, time 0
        uint256 startTime = block.timestamp;
        uint256 _endTime = startTime + timeInSeconds;

        listings[id] = Listing({
            nftOwner: Nft.ownerOf(id),
            tokenId: id,
            price: minPrice,
            isListed: true,
            endTime: _endTime
        });
        Nft.transferFrom(msg.sender, address(this), id);
    }

    //Auction Bidding
    function bidding(uint256 id, uint256 bidAmount) public {
        Listing memory listing = listings[id];
        require(
            bidAmount > highestBid[id],
            "bid amount should be higher than previous bid"
        );
        require(listing.isListed, "NFT not listed");
        require(block.timestamp < listing.endTime, "Nft Auction ended");
        require(
            basicToken.balanceOf(msg.sender) >= highestBid[id],
            "Insufficient funds"
        );

        if (highestBidder[id] != address(0)){
            basicToken.transfer(highestBidder[id], highestBid[id]);
        }

        highestBidder[id] = msg.sender;
        highestBid[id] = bidAmount;

        basicToken.transferFrom(msg.sender, address(this), highestBid[id]);
    }

    // Withdraw NFT Auction
    function withddrawAuction(uint256 id) public {
        listings[id] = Listing({
            nftOwner: address(0),
            tokenId: id,
            price: 0,
            isListed: false,
            endTime: block.timestamp
        });
        basicToken.transfer(highestBidder[id],highestBid[id]);
        Nft.transferFrom(address(this), Nft.ownerOf(id), id);
    }

    //Complete Auction
    function completeAuction(uint256 id) public {
        Listing memory listing = listings[id];

        require(block.timestamp >= listing.endTime, "Auction not ended yet");
        Nft.transferFrom(address(this), highestBidder[id], id);
    }

    }