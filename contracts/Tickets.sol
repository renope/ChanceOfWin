// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import '@openzeppelin/contracts/utils/structs/EnumerableMap.sol';
import '@openzeppelin/contracts/utils/structs/EnumerableSet.sol';

contract Tickets is Ownable {
    using EnumerableSet for EnumerableSet.AddressSet;
    using EnumerableMap for EnumerableMap.UintToAddressMap;

    struct Layout {
        uint256 totalPrize;
        uint256 totalSupply;
        EnumerableSet.AddressSet winners;
        EnumerableMap.UintToAddressMap ticketToOwner;
        mapping(address => uint256) memberSupply;
    }

    Layout l;

    uint256 numberOfWinners;
    function setNumberOfWinners(uint256 newNum) public onlyOwner {
        numberOfWinners = newNum;
    }

    constructor() {
        numberOfWinners = 10;
    }


    function winners() public view returns(address[] memory _winners) {
        uint256 _numberOfWinners = l.winners.length();
        _winners = new address[](_numberOfWinners);
        for (uint256 index; index < _numberOfWinners; index++) {
            _winners[index] = l.winners.at(index);
        }
    }

    function totalPrize() public view returns(uint256) {
        return l.totalPrize;
    }

    function totalSupply() internal view returns(uint256) {
        return l.totalSupply;
    }

    function memberSupply(address member) public view returns(uint256) {
        return l.memberSupply[member];
    }

    function ownerOf(uint256 ticketId) public view returns(address) {
        return l.ticketToOwner.get(ticketId);
    }


    function _exists(uint256 ticketId) internal view returns (bool) {
        return ticketId < totalSupply();
    }
    
    function _collectInPrize(uint256 amount) internal {
        l.totalPrize += amount;
    }

    function _purchaseTicket(address member, uint256 _numberOfTickets) internal {
        uint256 ticketId = totalSupply();

        for(uint256 index = 0; index < _numberOfTickets; index++){
            l.ticketToOwner.set(ticketId, member);
            ticketId++;
        }
        l.memberSupply[member] += _numberOfTickets;
        l.totalSupply += _numberOfTickets;
    }

    function _reset() internal {
        delete l;
    }
}
