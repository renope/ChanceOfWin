// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorInterface.sol";

/**
* @title check payments and manage prices.
*/
abstract contract PriceFeed is Ownable {

    //aggregator on mumbai
    AggregatorInterface constant AGGREGATOR_MATIC_USD_8 = AggregatorInterface(0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada);

    /**
    * @notice returns USD/MATIC last price by 18 decimal places required.
    */
    function USD_MATIC_18() internal view returns(uint256) {
        return uint256(10 ** 26 / AGGREGATOR_MATIC_USD_8.latestAnswer());
    }

    /**
    * @notice returns returns ticket price in cents.
    * @notice only owner of the contract can set ticket price in cents.
    */
    uint256 public ticketPriceInCents;
    function setTicketPriceInCents(uint256 _ticketPriceInCents) public onlyOwner {
        ticketPriceInCents = _ticketPriceInCents;
    }

    /**
    * @notice returns the ticket price in MATIC by 18 decimal places required.
    */
    function ticketPriceInWei() public view returns(uint256) {
        return USD_MATIC_18() * ticketPriceInCents / 100;
    }

    /**
    * @notice check if the user paid sufficient fee for the tickets.
    */
    function _checkPaidAmount(uint256 paidAmount, uint256 numberOfTickets) internal view {
        require(paidAmount >= numberOfTickets * ticketPriceInWei() * 95 / 100, "Lottery: insufficient fee");
    }
}