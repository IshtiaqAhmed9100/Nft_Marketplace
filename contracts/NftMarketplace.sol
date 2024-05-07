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
        Nft = IERC721(0xb08Ca63fa7Fc8c9E29f3823E5171979b5154682B);
        nftWallet = 0x617F2E2fD72FD9D5503197092aC168c91465E7f2;
    }

    //argument, transfre from
    function listNFT(uint256 id, uint256 price) public {
        
        transferFrom(nftWallet, address(this), id);

        listings[id] = Listing({
            nftOwner: Nft.ownerOf(id),
            tokenId: id,
            price: price,
            isListed: true
        });
    }

    //transfer back
    function delistNFT(uint256 tokenId) public {
        listings[tokenId].isListed = false;
        transferFrom(address(this), nftWallet, tokenId);
    }

    function buyNFT(uint256 tokenId) public payable {
        Listing memory listing = listings[tokenId];
        require(listing.isListed, "NFT not listed");
        require(
            basicToken.balanceOf(msg.sender) >= listing.price,
            "Insufficient funds"
        );

        basicToken.transferFrom(msg.sender, address(this), listing.price);
        Nft.transferFrom(address(this), msg.sender, tokenId);
        listings[tokenId].isListed = false;
    }

    function getnftIds() public view returns (uint256) {
        return nftIds.current();
    }

    function getsoldIds() public view returns (uint256) {
        return nftIds.current();
    }
}
