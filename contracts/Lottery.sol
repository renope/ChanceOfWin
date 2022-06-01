// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./PriceFeed.sol";
import "./ShareFees.sol";

contract Lottery is Ownable, ShareFees {
    
    uint256 public ticketPriceInCents;
    function setTicketPriceInCents(uint256 _ticketPriceInCents) public onlyOwner {
        ticketPriceInCents = _ticketPriceInCents;
    }

    function ticketPriceInWei() public view returns(uint256) {
        return USDPriceFeed.USD_MATIC_18() * ticketPriceInCents / 100;
    }

    function buyTicket(uint16 numberOfTickets) public payable {
        require(msg.value >= numberOfTickets * ticketPriceInWei() * 95 / 100, "Lottery: insufficient fee");
        uint256 availableAmount = _deductFees(msg.value);
    }

    function buyTicket(uint16 numberOfTickets, address referral) public payable {
        require(msg.value >= numberOfTickets * ticketPriceInWei() * 95 / 100, "Lottery: insufficient fee");
    }
}