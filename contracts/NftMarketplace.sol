// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract NftMarketplace is ERC721 {
    IERC20 public basicToken;
    IERC721 public Nft;

    using Counters for Counters.Counter;
    Counters.Counter public nftIds;

    address nftWallet;

    struct Listing {
        address nftOwner;
        uint256 tokenId;
        uint256 price;
        bool isListed;
    }

    mapping(uint256 => Listing) public listings;

    constructor() ERC721("NftMatketplace", "NFTM") {
        basicToken = IERC20(0x0a7180a063D06AfC0a5C69829b71062B6a4FED56);
        Nft = IERC721(0xCD4E0740d25793309303f4a121c9E9CbF06aD9b4);
    }

    //Listing NFT
    function listNFT(uint256 id, uint256 price) public {
        listings[id] = Listing({
            nftOwner: Nft.ownerOf(id),
            tokenId: id,
            price: price,
            isListed: true
        });
        Nft.transferFrom(msg.sender, address(this), id);
    }

    // De-listing NFT
    function delistNFT(uint256 id) public {
        listings[id] = Listing({
            nftOwner: address(0),
            tokenId: id,
            price: 0,
            isListed: false
        });
        Nft.transferFrom(address(this), msg.sender, id);
    }

    //Buying NFT
    function buyNFT(uint256 id) public payable {
        Listing memory listing = listings[id];
        require(listing.isListed, "NFT not listed");
        require(
            basicToken.balanceOf(msg.sender) >= listing.price,
            "Insufficient funds"
        );

        basicToken.transferFrom(msg.sender, address(this), listing.price);
        Nft.transferFrom(address(this), msg.sender, id);
        listings[id] = Listing({
            nftOwner: address(0),
            tokenId: id,
            price: 0,
            isListed: false
        });
    }

    function getnftIds() public view returns (uint256) {
        return nftIds.current();
    }
}
