// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./PriceFeed.sol";

contract Lottery {
    
    function ticketPrice() public view returns(uint256) {
        return USDPriceFeed.USD_MATIC_18();
    }

    function buyTicket(uint16 numberOfTickets, address referral) public payable {
        require(msg.value >= ticketPrice() * 95 / 100, "Lottery: insufficient fee");
    }
}