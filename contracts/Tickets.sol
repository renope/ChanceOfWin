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

    struct Round {
        bool hasStarted;
        uint256 totalPrize;
        uint256 totalSupply;
        EnumerableMap.UintToAddressMap ticketToOwner;
        mapping(address => uint256) memberSupply;
    }

    Round r;

    constructor() {
        numberOfWinners = 10;
    }

    function roundHasStarted() public view returns(bool) {
        return r.hasStarted;
    }

    modifier roundStarted() {
        require(roundHasStarted(), "Ticket: round has not started.");
        _;
    }

    function winners() public view returns(address[] memory winners_) {
        uint256 _numberOfWinners = _winners.length();
        winners_ = new address[](_numberOfWinners);
        for (uint256 index; index < _numberOfWinners; index++) {
            winners_[index] = _winners.at(index);
        }
    }

    function totalPrize() public view returns(uint256) {
        return r.totalPrize;
    }

    function totalSupply() internal view returns(uint256) {
        return r.totalSupply;
    }

    function memberSupply(address member) public view returns(uint256) {
        return r.memberSupply[member];
    }

    function ownerOf(uint256 ticketId) public view returns(address) {
        return r.ticketToOwner.get(ticketId);
    }


    function _exists(uint256 ticketId) internal view returns (bool) {
        return ticketId < totalSupply();
    }
    
    function _startRound() internal {
        if(!r.hasStarted){r.hasStarted = true;}
    }

    function _collectInPrize(uint256 amount) internal {
        r.totalPrize += amount;
    }

    function _purchaseTicket(address member, uint256 _numberOfTickets) internal {
        uint256 ticketId = totalSupply();

        for(uint256 index = 0; index < _numberOfTickets; index++){
            r.ticketToOwner.set(ticketId, member);
            ticketId++;
        }
        r.memberSupply[member] += _numberOfTickets;
        r.totalSupply += _numberOfTickets;
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
            r.ticketToOwner.remove(randId);
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
        delete r;
    }
}
