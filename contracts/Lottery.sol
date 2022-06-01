// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./PriceFeed.sol";
import "./Payments.sol";
import "./Tickets.sol";

contract Lottery is PriceFeed, Payments, Tickets {
    using EnumerableSet for EnumerableSet.AddressSet;
    using EnumerableMap for EnumerableMap.UintToAddressMap;

    event BuyTicket(address indexed buyer, uint256 numberOfTickets, uint256 paidAmount);

    function buyTicket(uint256 numberOfTickets) public payable {
        buyTicket(numberOfTickets, address(0));
    }

    function buyTicket(uint256 numberOfTickets, address referral) public payable {
        address ticketBuyer = msg.sender;
        uint256 paidAmount = msg.value;
        _checkPaidAmount(paidAmount, numberOfTickets);
        _register(ticketBuyer, referral);
        _shareFees(paidAmount * 30 / 100);
        _collectInPrize(paidAmount * 70 / 100);
        _purchaseTicket(ticketBuyer, numberOfTickets);
    }

    function trigger() public onlyOwner {
        _randSelectWinners();
    }
}