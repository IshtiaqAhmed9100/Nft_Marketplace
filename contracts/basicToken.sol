// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BasicToken is Ownable, ERC20 {


  constructor() Ownable(msg.sender) ERC20("BasicToken","BT"){}

  function mint() public {
    _mint(msg.sender, 1000 * (10 **18));
  }
}