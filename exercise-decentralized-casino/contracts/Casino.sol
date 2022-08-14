// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

import "./usingProvable.sol";

contract Casino is usingProvable {
    address public owner;
    uint256 public minimumBet = 0.1 ether;
    uint256 public maximumBet = 10 ether;
    uint256 public numberOfBets;
    uint256 public maxNumberOfBets = 100;
    uint256 public winningNumber;

    address[] public players;
    mapping(address => uint256) public playerBets;
    mapping(uint256 => address payable[]) public bets;

    event generatedRandomNumber(string randomNumber);
    event LogNewProvableQuery(string description);

    constructor(uint256 _minimumBet, uint256 _maxNumberOfBets) public {
        owner = msg.sender;

        if (_minimumBet > 0) {
            minimumBet = _minimumBet;
        }

        if (_maxNumberOfBets > 0) {
            maxNumberOfBets = _maxNumberOfBets;
        }

        provable_setProof(proofType_Ledger);
    }

    function bet(uint256 numberToBet) public payable {
        require(numberOfBets < maxNumberOfBets, "Bet table is full.");
        require(
            numberToBet >= 1 && numberToBet <= 10, 
            "Choose a bet number between 1 and 10."
        );
        require(
            msg.value >= minimumBet,
            "Bet is less than specified minimum bet."
        );
        require(
            playerBets[msg.sender] == 0,
            "You are not allowed to change your bet."
        );

        playerBets[msg.sender] = numberToBet;
        bets[numberToBet].push(msg.sender);
        players.push(msg.sender);

        numberOfBets += 1;

        if (numberOfBets >= maxNumberOfBets) {
            generateWinningNumber();
        }
    }

    function generateWinningNumber() public payable {
        uint256 delay = 0;
        uint256 numberRandomBytes = 7;
        uint256 callbackGasLimit = 400000;

        provable_newRandomDSQuery(delay, numberRandomBytes, callbackGasLimit);
        emit LogNewProvableQuery(
            "Provable query was sent, standing by for the answer..."
        );
    }

    function __callback(
        bytes32 _queryID,
        string memory _result,
        bytes memory _proof
    ) public {
        require(msg.sender == provable_cbAddress(), "Bad callback");
        require(
            provable_randomDS_proofVerify__returnCode(
                _queryID, 
                _result, 
                _proof
            ) ==
                0,
            "Bad proof"
        );
        emit generatedRandomNumber(_result);

        bytes32 encodedRandom = keccak256(abi.encodePacked(_result));
        winningNumber = (uint256(encodedRandom) % 10) + 1;
        distributePrizes();
    }

    function distributePrizes() public {
        uint256 winningBets = bets[winningNumber].length;

        if (winningBets != 0) {
            uint256 prize = address(this).balance / winningBets;

            for (uint256 i = 0; i < winningBets; i++) {
                address payable winner = bets[winningNumber][i];
                winner.transfer(prize);
            }
        }

        resetBets();
    }

    function resetBets() private {
        for (uint256 i = 1; i <= 10; i++) {
            bets[i].length = 0;
        }

        for (uint256 i = 0; i < players.length; i++) {
            playerBets[players[i]] = 0;
        }

        numberOfBets = 0;
    }

    function getContractBalance() public view returns(uint256 balance) {
        return address(this).balance;
    }
}
