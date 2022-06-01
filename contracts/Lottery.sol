// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./PriceFeed.sol";
import "./ShareFees.sol";

contract Lottery is Ownable, ShareFees {
    
    uint256 totalPrize;

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
        _shareFees30(paidAmount * 30 / 100);
    }

    function buyTicket(uint16 numberOfTickets, address referral) public payable {
        uint256 paidAmount = msg.value;
        require(paidAmount >= numberOfTickets * ticketPriceInWei() * 95 / 100, "Lottery: insufficient fee");
        _shareCommissions(paidAmount * 5 / 100, referral);
        _shareFees25(paidAmount * 25 / 100);
    }
}