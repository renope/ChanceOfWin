// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Lottery {
    
    function ticketFee() public view returns(uint256) {
        
    }

    function buyTicket(uint16 numberOfTickets, address referral) public payable {
        require(msg.value >= tiketPrice(), "Lottery: insufficient fee");
    }
}