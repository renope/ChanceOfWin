// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

abstract contract ShareCommissions {

    mapping(address => address) referrals;

    function _shareCommissions(uint256 amount) internal returns(uint256 rest){
    }

    function _pay(address receiver, uint256 amount) internal {
        payable(receiver).transfer(amount);
    }
}
