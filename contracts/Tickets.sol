// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import '@openzeppelin/contracts/utils/structs/EnumerableMap.sol';
import '@openzeppelin/contracts/utils/structs/EnumerableSet.sol';

contract Tickets {
    using EnumerableSet for EnumerableSet.UintSet;
    using EnumerableMap for EnumerableMap.UintToAddressMap;

    struct Layout {
        uint256 totalPrize;
        EnumerableMap.UintToAddressMap ticketOwners;
        mapping(address => EnumerableSet.UintSet) holderTickets;
    }

    Layout l;

    
    function _collect(uint256 amount) internal {
        l.totalPrize += amount;
    }

    function totalSupply() internal view returns (uint256) {
        return l.ticketOwners.length();
    }

    function exists(uint256 ticketId)
        internal
        view
        returns (bool)
    {
        return l.ticketOwners.contains(ticketId);
    }

    function ticketOfOwnerByIndex(
        address owner,
        uint256 index
    ) internal view returns (uint256) {
        return l.holderTickets[owner].at(index);
    }

    function ticketByIndex(uint256 index)
        internal
        view
        returns (uint256)
    {
        (uint256 ticketId, ) = l.ticketOwners.at(index);
        return ticketId;
    }






    function registered(address member) internal view returns(bool) {
        return l.holderTickets[member].length() != 0;
    }
}
