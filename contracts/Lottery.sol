// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Tickets.sol";
import "./PriceFeed.sol";
import "./ShareFees.sol";

contract Lottery is Tickets, Ownable, ShareFees {

    uint256 public ticketPriceInCents;
    function setTicketPriceInCents(uint256 _ticketPriceInCents) public onlyOwner {
        ticketPriceInCents = _ticketPriceInCents;
    }

    function ticketPriceInWei() public view returns(uint256) {
        return USDPriceFeed.USD_MATIC_18() * ticketPriceInCents / 100;
    }

    function buyTicket(uint16 numberOfTickets) public payable {
        uint256 paidAmount = msg.value;
        require(paidAmount >= numberOfTickets * ticketPriceInWei() * 95 / 100, "Lottery: insufficient fee");
        _register(msg.sender);
        _shareFees(paidAmount * 30 / 100);
        _collectInPrize(paidAmount * 70 / 100);
        _purchaseTicket(msg.sender, numberOfTickets);
    }

    function buyTicket(uint16 numberOfTickets, address referral) public payable {
        uint256 paidAmount = msg.value;
        require(paidAmount >= numberOfTickets * ticketPriceInWei() * 95 / 100, "Lottery: insufficient fee");
        _register(msg.sender, referral);
        _shareFees(paidAmount * 30 / 100);
        _collectInPrize(paidAmount * 70 / 100);
        _purchaseTicket(msg.sender, numberOfTickets);
    }
}