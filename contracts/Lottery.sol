// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./PriceFeed.sol";
import "./Payments.sol";
import "./Tickets.sol";

    /**
     * @title main lottery contract.
     *
     * @notice steps:
     *
     * 1- every round starts by the owner of the contract.
     * 2- users buy tickets.
     * 3- participants are paid 30 percent of the ticket value.
     * 3- the rest 70 of the ticket value is collected in total prize.
     * 4- owner of the contract triggers.
     * 4- winners are selected by random.
     * 5- total prize is shared between winners.
     */
contract ChanceOfWin is PriceFeed, Payments, Tickets {
    event BuyTicket(
        address indexed buyer,
        uint256 numberOfTickets,
        uint256 paidAmount
    );

    /**
     * @notice starts the round, so users can buy tickets after that.
     * @notice only owner of the contract can call this function.
     */
    function startRound() public onlyOwner {
        _startRound();
    }

    /**
     * @notice purchase desired number of tickets and participate in the lottery.
     * @notice the round should be started.
     * @notice user should pay sufficient fee to purchase the tickets.
     */
    function buyTicket(uint256 numberOfTickets) public payable roundStarted {
        buyTicket(numberOfTickets, address(0));
    }

    /**
     * @notice purchase desired number of tickets and participate in the lottery.
     * @notice the round should be started.
     * @notice user should pay sufficient fee to purchase the tickets.
     * @notice user can inset a referral address to earn referral commissions.
     */
    function buyTicket(uint256 numberOfTickets, address referral)
        public
        payable
        roundStarted
    {
        address ticketBuyer = msg.sender;
        uint256 paidAmount = msg.value;
        _checkPaidAmount(paidAmount, numberOfTickets);
        _register(ticketBuyer, referral);
        _shareFees((paidAmount * 30) / 100);
        _collectInPrize((paidAmount * 70) / 100);
        _purchaseTicket(ticketBuyer, numberOfTickets);
    }

    /**
     * @notice ends the round.
     *
     * @notice selects the winners by random.
     * @notice shares the prize among winners.
     * @notice resets the variables of the round.
     */
    function trigger() public onlyOwner {
        _randSelectWinners();
        _sharePrizes(winners(), totalPrize());
        _resetRound();
    }
}