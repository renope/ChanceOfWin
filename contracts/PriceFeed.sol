// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorInterface.sol";

abstract contract PriceFeed is Ownable {

    //aggregator on mumbai
    AggregatorInterface constant AGGREGATOR_MATIC_USD_8 = AggregatorInterface(0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada);

    function USD_MATIC_18() internal view returns(uint256) {
        return uint256(10 ** 26 / AGGREGATOR_MATIC_USD_8.latestAnswer());
    }

    uint256 public ticketPriceInCents;
    function setTicketPriceInCents(uint256 _ticketPriceInCents) public onlyOwner {
        ticketPriceInCents = _ticketPriceInCents;
    }

    function ticketPriceInWei() public view returns(uint256) {
        return USD_MATIC_18() * ticketPriceInCents / 100;
    }

    function _checkPaidAmount(uint256 paidAmount, uint256 numberOfTickets) internal view {
        require(paidAmount >= numberOfTickets * ticketPriceInWei() * 95 / 100, "Lottery: insufficient fee");
    }
}