// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";

abstract contract Payments is Ownable {

    /**
    * @notice returns the team wallet address.
    * @notice only the team address itself can set a new address.
    */
    address public team;
    function setTeamAddr(address newAddr) public {
        require(msg.sender == team, "Payments: you have not access");
        team = newAddr;
    }

    /**
    * @notice returns the company wallet address.
    * @notice only the company address itself can set a new address.
    */
    address public company;
    function setCompanyAddr(address newAddr) public {
        require(msg.sender == company, "Payments: you have not access");
        company = newAddr;
    }

    mapping(address => address) referrals;
    mapping(address => bool) registered;

    constructor() {
        //initializing address of the team and the company (should be set)
        team = 0x0cE446255506E92DF41614C46F1d6df9Cc969183;
        company = 0x0cE446255506E92DF41614C46F1d6df9Cc969183;
    }

    function _register(address member, address referral) internal {
        if(!registered[member]){
            registered[member] = true;
        }
        if(referral != address(0) && referrals[member] == address(0)){
            referrals[member] = referral;
        }
    }


//////// internal functions ///////////

    /**
    * @notice shares the rest 30 percent of user paid value among project contributers.
    */
    function _shareFees(uint256 _30Percent) internal {
        if(referrals[msg.sender] == address(0)) {
            _shareFees30(_30Percent);
        } else {
            _shareCommissions(_30Percent * 5 / 30, referrals[msg.sender]);
            _shareFees25(_30Percent * 25 / 30);
        }
    }

    /**
    * @notice shares all the 30 percent of user paid value among project contributers
    * (no referrals commission).
    */
    function _shareFees30(uint256 _30Percent) internal {
        _pay(owner(), _30Percent * 5 / 30);
        _pay(team, _30Percent * 5 / 30);
        _pay(company, _30Percent * 20 / 30);
    }

    /**
    * @notice shares all the 25 percent of user paid value among project contributers
    * (preserve 5 percent referrals commission).
    */
    function _shareFees25(uint256 _25Percent) internal {
        _pay(owner(), _25Percent * 5 / 25);
        _pay(team, _25Percent * 5 / 25);
        _pay(company, _25Percent * 20 / 25);
    }

    /**
    * @notice shares 5 percent of user paid value among the referral addresses.(contains 
    * up to 5 upper referrals)
    */
    function _shareCommissions(uint256 amount, address referral) internal {
    require(registered[referral],"Lottery: unregistered referral address");
        uint256 refCount;
        do{refCount += 1;} while(referrals[referral] != address(0) && refCount < 5);
        for(uint256 index; index < refCount; index++) {
            _pay(referral, amount / refCount);
            referral = referrals[referral];
        }
    }

    /**
    * @notice shares the total prize among the winners equally.
    */
    function _sharePrizes(address[] memory winners_, uint256 amount) internal {
        uint256 _numberOfwinners = winners_.length;
        for(uint256 index; index < _numberOfwinners; index++) {
            _pay(winners_[index], amount / _numberOfwinners);
        }
    }

    /**
    * @notice transfers the amount in wei from contract address to the payable
    * receiver address.
    */
    function _pay(address receiver, uint256 amount) internal {
        payable(receiver).transfer(amount);
    }
}
