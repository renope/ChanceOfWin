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

    function _shareCommissions(uint256 amount, address referral) internal returns(uint256 rest){
        uint256 refCount;
        
    }

    function _pay(address receiver, uint256 amount) internal {
        payable(receiver).transfer(amount);
    }
}
