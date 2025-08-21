// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts@4.9.0/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.9.0/access/Ownable.sol";

contract RFXToken is ERC20, Ownable {
    address public feeRecipient;
    uint256 public earlySellFee; // percentage (e.g., 5 means 5%)

    mapping(address => uint256) public lastBuyTime;
    mapping(address => uint256) public lastSellTime;
    mapping(address => uint256) public receivedTime;

    uint256 public constant BUY_LIMIT = 2 * 10**18;  // 2 RFX
    uint256 public constant SELL_LIMIT = 1 * 10**18; // 1 RFX
    uint256 public constant COOLDOWN_PERIOD = 8 hours;
    uint256 public constant EARLY_SELL_DAYS = 7 days;

    constructor(
        string memory name_,
        string memory symbol_,
        uint256 initialSupply_,
        address feeRecipient_,
        uint256 earlySellFee_
    ) ERC20(name_, symbol_) {
        _mint(msg.sender, initialSupply_);
        feeRecipient = feeRecipient_;
        earlySellFee = earlySellFee_;
    }

    function _transfer(address from, address to, uint256 amount) internal override {
        if (from != owner() && to != owner()) {
            if (to != address(0)) {
                // Buy
                require(block.timestamp >= lastBuyTime[to] + COOLDOWN_PERIOD, "Buy cooldown active");
                require(amount <= BUY_LIMIT, "Buy limit exceeded");
                lastBuyTime[to] = block.timestamp;
                receivedTime[to] = block.timestamp;
            }
            if (from != address(0)) {
                // Sell
                require(block.timestamp >= lastSellTime[from] + COOLDOWN_PERIOD, "Sell cooldown active");
                require(amount <= SELL_LIMIT, "Sell limit exceeded");
                lastSellTime[from] = block.timestamp;

                // Early sell fee
                if (block.timestamp < receivedTime[from] + EARLY_SELL_DAYS) {
                    uint256 feeAmount = (amount * earlySellFee) / 100;
                    super._transfer(from, feeRecipient, feeAmount);
                    amount -= feeAmount;
                }
            }
        }
        super._transfer(from, to, amount);
    }
}
