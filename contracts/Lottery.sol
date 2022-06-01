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
        if(!registered[msg.sender]){
            registered[msg.sender] = true;
        }
        _shareFees(paidAmount);
        _collect(paidAmount * 70 / 100);
    }

    function buyTicket(uint16 numberOfTickets, address referral) public payable {
        uint256 paidAmount = msg.value;
        require(paidAmount >= numberOfTickets * ticketPriceInWei() * 95 / 100, "Lottery: insufficient fee");
        if(!registered[msg.sender]){
            referrals[msg.sender] = referral;
            registered[msg.sender] = true;
        }
        _shareFees(paidAmount);
        _collect(paidAmount * 70 / 100);
    }
}