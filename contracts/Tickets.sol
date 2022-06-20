// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import '@openzeppelin/contracts/utils/structs/EnumerableMap.sol';
import '@openzeppelin/contracts/utils/structs/EnumerableSet.sol';

/**
 * @title tickets management
 */
contract Tickets is Ownable {
    using EnumerableSet for EnumerableSet.AddressSet;
    using EnumerableMap for EnumerableMap.UintToAddressMap;

    EnumerableSet.AddressSet _winners;
    

    /**
    * @notice number of users that prize will be shared between them on current round.
    * @notice can be set by owner of the contract.
    */
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

    /**
    * @notice returns true if round has started and users can buy tickets.
    */
    function roundHasStarted() public view returns(bool) {
        return r.hasStarted;
    }

    /**
    * @notice give access to execute function only when round has started.
    */
    modifier roundStarted() {
        require(roundHasStarted(), "Ticket: round has not started.");
        _;
    }

    /**
    * @notice returns an array of winners of the last round.
    */
    function winners() public view returns(address[] memory winners_) {
        uint256 _numberOfWinners = _winners.length();
        winners_ = new address[](_numberOfWinners);
        for (uint256 index; index < _numberOfWinners; index++) {
            winners_[index] = _winners.at(index);
        }
    }

    /**
    * @notice returns the user address who owns the specified ticket.
    */
    function ownerOf(uint256 ticketId) public view returns(address) {
        return r.ticketToOwner.get(ticketId);
    }

    /**
    * @notice returns total prize that has been collected until now.
    */
    function totalPrize() public view returns(uint256) {
        return r.totalPrize;
    }


    /**
    * @notice returns number of tickets of specified user address.
    */
    function memberSupply(address member) public view returns(uint256) {
        return r.memberSupply[member];
    }



/////// internal functions ////////


    /**
    * @notice returns number of tickets has been minted until this moment.
    */
    function totalSupply() internal view returns(uint256) {
        return r.totalSupply;
    }

    /**
    * @notice returns true if such a ticketId has been minted.
    */
    function _exists(uint256 ticketId) internal view returns (bool) {
        return ticketId < totalSupply();
    }
    
    /**
    * @notice internal funcion that starts the round.
    */
    function _startRound() internal {
        if(!r.hasStarted){r.hasStarted = true;}
    }

    /**
    * @notice add specified amount to the total prize.
    */
    function _collectInPrize(uint256 amount) internal {
        r.totalPrize += amount;
    }

    /**
    * @notice assign a number of tickets to a user address.
    */
    function _purchaseTicket(address member, uint256 _numberOfTickets) internal {
        uint256 ticketId = totalSupply();

        for(uint256 index = 0; index < _numberOfTickets; index++){
            r.ticketToOwner.set(ticketId, member);
            ticketId++;
        }
        r.memberSupply[member] += _numberOfTickets;
        r.totalSupply += _numberOfTickets;
    }


    /**
    * @notice select the winners by random and fill the winners array.
    */
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

    /**
    * @notice genarates a uint256 random number by keccak256 hashing the block attributes and a certain nonce.
    */
    function _randomUint256(uint256 nonce) internal view returns(uint256) {
        return uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, nonce)));
    }

    /**
    * @notice resets the winners array.
    */
    function _resetWinners() internal {
        delete _winners;
    }

    /**
    * @notice resets the round variables.
    */
    function _resetRound() internal {
        delete r;
    }
}
