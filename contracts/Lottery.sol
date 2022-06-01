// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./PriceFeed.sol";

contract Lottery is Ownable {
    
    function ticketPrice() public view returns(uint256) {
        return USDPriceFeed.USD_MATIC_18();
    }

    function buyTicket(uint16 numberOfTickets, address referral) public payable {
        require(msg.value >= numberOfTickets * ticketPrice() * 95 / 100, "Lottery: insufficient fee");
    }
}