// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";

abstract contract ShareFees is Ownable {

    address public team;
    address public company;

    constructor() {
        team = 0x0cE446255506E92DF41614C46F1d6df9Cc969183;
        company = 0x0cE446255506E92DF41614C46F1d6df9Cc969183;
    }

    function _shareFees(uint256 paidAmount) internal {
        if(referrals[msg.sender] != address(0)) {
            _shareCommissions(paidAmount * 5 / 100, referrals[msg.sender]);
            _shareFees25(paidAmount * 25 / 100);
        } else {
            _shareFees30(paidAmount * 30 / 100);
        }
    }

    function _shareFees30(uint256 paidAmount) internal {
        _pay(owner(), paidAmount * 5 / 30);
        _pay(team, paidAmount * 5 / 30);
        _pay(company, paidAmount * 20 / 30);
    }

    function _shareFees25(uint256 paidAmount) internal {
        _pay(owner(), paidAmount * 5 / 25);
        _pay(team, paidAmount * 5 / 25);
        _pay(company, paidAmount * 20 / 25);
    }

    mapping(address => address) referrals;
    mapping(address => bool) registered;

    function _register(address member) internal {
        if(!registered[member]){
            registered[member] = true;
        }
    }
    function _register(address member, address referral) internal {
        if(!registered[member]){registered[member] = true;}
        if(referrals[member] == address(0)){referrals[member] = referral;}
    }

    function _shareCommissions(uint256 amount, address referral) internal{
    require(registered[referral],"Lottery: unregistered referral address");
        uint256 refCount;
        do{refCount += 1;} while(referrals[referral] != address(0) && refCount < 5);
        for(uint256 index; index < refCount; index++) {
            _pay(referral, amount / refCount);
            referral = referrals[referral];
        }
    }

    function _pay(address receiver, uint256 amount) internal {
        payable(receiver).transfer(amount);
    }
}
