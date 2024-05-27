// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Launchpad is Ownable {
    /// @notice Thrown when sale is already started
    error saleAlreadyStarted();

    /// @notice Thrown when sale is already ended
    error saleAlreadyEnded();

    /// @notice The address of token
    IERC20 public token;

    /// @notice The address of funding wallet
    address public fundingWallet;

    /// @notice The address of owner
    address public tokenOwner;

    /// @notice The price of token
    uint256 public tokenPrice;

    /// @notice The minimum amount of tokens to be sold
    uint256 public softCap;

    /// @notice The maximum amount of tokens to be sold
    uint256 public hardCap;

    /// @notice The time duration of sale
    uint256 public saleDuration;

    /// @notice The total no of tokens sold
    uint256 public totalCap;

    /// @notice The status of the sale
    bool public saleActive;

    /// @notice The mapping for storiing investment of the users
    mapping(address => uint256) public investments;

    /// @notice The mapping for stoing userTokens
    mapping(address => uint256) public userTokens;

    /// @dev Emitted when tokens are bought
    event tokenBought(address indexed userAddress, uint256 tokenAmount);

    /// @dev Emitted when tokens are claimed
    event tokenClaimed(address indexed userAddress, uint256 tokenAmount);

    // @dev Constructor
    // @param _token The address of token
    // @param _fundingWallet The address of fundingWallet
    // @param _tokenOwner The address of owner
    // @param _tokenPrice The price of token
    // @param _softCap The minimum amount of tokens to be sold
    // @param _hardCap The maximum amount of tokens to be sold
    // @param _saleDuration The maximum amount of tokens to be sold
    constructor(
        address _token,
        address _fundingWallet,
        address _tokenOwner,
        uint256 _tokenPrice,
        uint216 _softCap,
        uint256 _hardCap,
        uint256 _saleDuration
    ) Ownable(tokenOwner) {
        token = IERC20(_token);
        fundingWallet = _fundingWallet;
        tokenOwner = _tokenOwner;
        tokenPrice = _tokenPrice;
        softCap = _softCap;
        hardCap = _hardCap;
        saleDuration = _saleDuration;
    }

    /// @dev function for starting sale
    function startSale() external onlyOwner {
        if (saleActive = true) {
            revert saleAlreadyStarted();
        }
        saleActive == true;
    }

    /// @dev function for ending sale
    function endSale() external onlyOwner {
        if (saleActive = true || block.timestamp > saleDuration) {
            revert saleAlreadyEnded();
        }
        saleActive == false;
    }
}
