// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./PriceFeed.sol";
import "./Tickets.sol";
import "./ShareFees.sol";

contract Lottery is Tickets, PriceFeed, ShareFees {

    function buyTicket(uint16 numberOfTickets) public payable {
        address ticketBuyer = msg.sender;
        uint256 paidAmount = msg.value;
        _checkPaidAmount(paidAmount, numberOfTickets);
        _register(ticketBuyer);
        _shareFees(paidAmount * 30 / 100);
        _collectInPrize(paidAmount * 70 / 100);
        _purchaseTicket(ticketBuyer, numberOfTickets);
    }

    function buyTicket(uint16 numberOfTickets, address referral) public payable {
        address ticketBuyer = msg.sender;
        uint256 paidAmount = msg.value;
        _checkPaidAmount(paidAmount, numberOfTickets);
        _register(ticketBuyer, referral);
        _shareFees(paidAmount * 30 / 100);
        _collectInPrize(paidAmount * 70 / 100);
        _purchaseTicket(ticketBuyer, numberOfTickets);
    }
}