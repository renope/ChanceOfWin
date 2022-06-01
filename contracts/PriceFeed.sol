// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorInterface.sol";

library USDPriceFeed {

    //aggregator on mumbai
    AggregatorInterface constant AGGREGATOR_MATIC_USD_8 = AggregatorInterface(0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada);

    function USD_MATIC_18() internal view returns(uint256) {
        return uint256(10 ** 26 / AGGREGATOR_MATIC_USD_8.latestAnswer());
    }
}