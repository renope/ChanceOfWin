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

    function _shareFees(uint256 paidAmount) internal{
        _pay(owner(), paidAmount * 5 / 30);
        _pay(team, paidAmount * 5 / 30);
        _pay(company, paidAmount * 20 / 30);
    }

    function _pay(address receiver, uint256 amount) internal {
        payable(receiver).transfer(amount);
    }
}
