// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Counters} from "@openzeppelin/utils/Counters.sol";

contract Nft is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter public nftId;
    address  nftWallet;

    constructor() Ownable(msg.sender) ERC721("BasicERC721", "B721") {
        nftWallet = 0x617F2E2fD72FD9D5503197092aC168c91465E7f2;
    }

    function mint() external payable {
        nftId.increment();
        _mint(nftWallet, nftId.current());
    }

    function transferNft(uint256 nftNo, address contractAdd) public {
        _transfer(nftWallet,contractAdd , nftNo);
    }

    function getIds() public view returns(uint256){
        return nftId.current();
    }

}
