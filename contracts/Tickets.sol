// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import '@openzeppelin/contracts/utils/structs/EnumerableMap.sol';
import '@openzeppelin/contracts/utils/structs/EnumerableSet.sol';

contract Tickets {
    using EnumerableSet for EnumerableSet.UintSet;
    using EnumerableMap for EnumerableMap.UintToAddressMap;

    struct Layout {
        address[] winners;
        uint256 totalPrize;
        uint256 totalSupply;
        mapping(uint256 => address) ticketToOwner;
        mapping(address => uint256) memberSupply;
    }

    Layout l;

    function winners() public view returns(address[] memory) {
        return l.winners;
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

    
    function _collectInPrize(uint256 amount) internal {
        l.totalPrize += amount;
    }

    function _exists(uint256 ticketId) internal view returns (bool) {
        return ticketId < totalSupply();
    }

    function _purchaseTicket(address member, uint256 _numberOfTickets) internal {
        uint256 ticketId = totalSupply();
        address ticketHolder = member;

        for(uint256 index = 0; index < _numberOfTickets; index++){
            l.ticketToOwner[ticketId] = ticketHolder;
            ticketId++;
        }
        l.ticketToOwner[ticketId] = member;
        l.memberSupply[member] += _numberOfTickets;
        l.totalSupply += _numberOfTickets;
    }

    function _reset() internal {
        delete l;
    }
}
