// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

abstract contract ShareCommissions {

    mapping(address => address) referrals;

    function _deductCommissions(uint256 amount) internal returns(uint256 rest){
        _pay(owner(), amount * 5 / 100);
        _pay(team, amount * 5 / 100);
        _pay(company, amount * 20 / 100);
    }

    function _pay(address receiver, uint256 amount) internal {
        payable(receiver).transfer(amount);
    }
}
