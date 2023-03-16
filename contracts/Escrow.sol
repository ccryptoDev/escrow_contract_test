//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./AAToken.sol";
import "./BBToken.sol";

contract Escrow is Ownable, ReentrancyGuard {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    AAToken public aToken;
    BBToken public bToken;

    struct Transaction {
        address seller;
        address buyer;
        uint256 aToken_amount;
        uint256 bToken_amount;
    }

    struct Trade {
        address seller;
        uint256 amount;
        uint256 fromDate;
        uint256 endDate;
    }

    Trade public trade;
    mapping(address => Transaction) private escrowTransaction;

    // events
    event CreateTrade(address seller, uint256 amount);
    event ExecuteTrade(address buyer, uint256 amount);

    constructor(AAToken _aTokenAddr, BBToken _bTokenAddr) {
        aToken = _aTokenAddr;
        bToken = _bTokenAddr;
    }
    
    /**
     * @notice A method to create a trade - escrow will hold a trade (seller -> escrow).
     * @param _seller the address of a seller.
     * @param _amount the amount of token.
     * @param _fromDate from when a sale is valid
     * @param _endDate to when a sale is valid
     */
    function createTrade(address _seller, uint256 _amount, uint256 _fromDate, uint256 _endDate) public payable returns (bool) {
        // Transfer token A to Escrow
        require(
            aToken.transferFrom(msg.sender, address(this), _amount),
            "aToken transaction failed!"
        );
        
        // Record a trade inform
        trade = Trade(_seller, _amount, _fromDate, _endDate);

        emit CreateTrade(_seller, _amount);
        return true;
    }

    /**
     * @notice A method to execute a trade - (aToken: escrow -> buyer, bToken: buyer -> seller).
     * @param _trader the address of a buyer.
     * @param _amount the amount of token.
     */
    function executeTrade(address _trader, uint256 _amount, uint256 _now) public payable returns (bool) {
        // Check if there is proper trade and a trade is vaid with time
        require(trade.seller, "a trade not existed!");
        require(
            now > trade.fromDate && now <= trade.endDate,
            "There is no valid trade" 
        );

        // Release tokens in Escrow (escrow -> trader)
        aToken.transferFrom(address(this), _trader, trade.amount);

        // Trader sends bToken to seller as much as aToken in trade
        bToken.transferFrom(_trader, trade.seller, _amount);

        // Record transaction
        escrowTransaction[address(this)].seller = trade.seller;
        escrowTransaction[address(this)].buyer = _trader;
        escrowTransaction[address(this)].aToken_amount = trade.amount;
        escrowTransaction[address(this)].bToken_amount = _amount;

        // Delete a trade
        trade = Trade('', 0, '', '');

        emit ExecuteTrade(_trader, _amount);
        return true;
    }

    /**
     * @notice A method to cancel a trade - the token in escrow will be back to the seller
     * @param _seller the address of a seller to cancel a trade.
     */
    function cancelTrade(address _seller) public payable returns(bool) {
        aToken.transferFrom(address(this), _seller, trade.amount);

        // Delete a trade
        trade = Trade('', 0, '', '');
        return true;
    }

}
