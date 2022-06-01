// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./PriceFeed.sol";

contract Lottery is Ownable {
    
    address immutable public team = 0x0cE446255506E92DF41614C46F1d6df9Cc969183;
    address immutable public company = 0x0cE446255506E92DF41614C46F1d6df9Cc969183;

    uint256 public ticketPriceInCents;
    function setTicketPriceInCents(uint256 _ticketPriceInCents) public onlyOwner {
        ticketPriceInCents = _ticketPriceInCents;
    }

    function ticketPriceInWei() public view returns(uint256) {
        return USDPriceFeed.USD_MATIC_18() * ticketPriceInCents / 100;
    }

    function buyTicket(uint16 numberOfTickets) public payable {
        require(msg.value >= numberOfTickets * ticketPriceInWei() * 95 / 100, "Lottery: insufficient fee");
    }

    function buyTicket(uint16 numberOfTickets, address referral) public payable {
        require(msg.value >= numberOfTickets * ticketPriceInWei() * 95 / 100, "Lottery: insufficient fee");
    }
}