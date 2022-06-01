// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./PriceFeed.sol";
import "./ShareFees.sol";
import "./Tickets.sol";

contract Lottery is PriceFeed, ShareFees, Tickets {
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

    function _randSelectWinners() internal {
        uint256 supply = totalSupply();
        uint256 randId;
        address winner;
        while(l.winners.length() < numberOfWinners) {
            randId = _randomUint256(randId) % supply;
            winner = ownerOf(randId);
            l.ticketToOwner.remove(randId);
            supply--;
            l.winners.add(winner);
        }
    }


    function _randomUint256(uint256 nonce) internal view returns(uint256) {
        return uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, nonce)));
    }
}