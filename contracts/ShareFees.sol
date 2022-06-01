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

    function _deductFees(uint256 paidAmount) internal returns(uint256 rest){
        _pay(owner(), paidAmount * 5 / 100);
        _pay(team, paidAmount * 5 / 100);
        _pay(company, paidAmount * 20 / 100);
        rest = paidAmount * 70 / 100;
    }

    function _pay(address receiver, uint256 amount) internal {
        payable(receiver).transfer(amount);
    }
}
