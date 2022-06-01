// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import '@openzeppelin/contracts/utils/structs/EnumerableMap.sol';
import '@openzeppelin/contracts/utils/structs/EnumerableSet.sol';

contract Tickets is Ownable {
    using EnumerableSet for EnumerableSet.AddressSet;
    using EnumerableMap for EnumerableMap.UintToAddressMap;

    EnumerableSet.AddressSet _winners;
    
    uint256 numberOfWinners;
    function setNumberOfWinners(uint256 newNum) public onlyOwner {
        numberOfWinners = newNum;
    }

    struct Layout {
        uint256 totalPrize;
        uint256 totalSupply;
        EnumerableMap.UintToAddressMap ticketToOwner;
        mapping(address => uint256) memberSupply;
    }

    Layout l;

    constructor() {
        numberOfWinners = 10;
    }


    function winners() public view returns(address[] memory winners_) {
        uint256 _numberOfWinners = _winners.length();
        winners_ = new address[](_numberOfWinners);
        for (uint256 index; index < _numberOfWinners; index++) {
            winners_[index] = _winners.at(index);
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


    function _randSelectWinners() internal {
        uint256 supply = totalSupply();
        require(supply >= numberOfWinners,
            "Tickets: number of tickets has not been reached the qourum");
        _resetWinners();
        uint256 randId;
        address winner;
        while(_winners.length() < numberOfWinners) {
            randId = _randomUint256(randId) % supply;
            winner = ownerOf(randId);
            l.ticketToOwner.remove(randId);
            supply--;
            _winners.add(winner);
        }
    }

    function _randomUint256(uint256 nonce) internal view returns(uint256) {
        return uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, nonce)));
    }

    function _resetWinners() internal {
        delete _winners;
    }

    function _resetRound() internal {
        delete l;
    }
}
