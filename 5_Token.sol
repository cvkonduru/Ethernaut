/* 

You are given 20 tokens to start with and you will beat the level if you somehow manage to get your hands on any additional tokens.
Preferably a very large amount of tokens.


contract name is Token
contract has a state variable called balance, which is a mapping of address to uint.
contract has a state variable called totalSupply which is public and of type uint. This gets a getter function automatically.

contract has a constructor that takes an argument _initialSupply uint. 
constructor sets the balance of the contract deployer address to the _initialSuppy and also the initialSupply is assigned to total Supply.
So totalSupply = _initialSupply.
balances[contractOwner] = _initialSupply

contract has a function called transfer which takes two arguments _to which is of type address and _value which is of type uint.
function transfers a bool.

transfer function basicaly requires the balance of the caller should always be greater than or equal to  the _value specified.

So balance[msg.sender] - value >= 0; is the condition check that's performed. Once the check passes.
balances[msg.sender] -= _value; -- caller balance is reduced by _value and 
balances[_to] += value; -- _to balance is increased by _value. and true is returned.

contract contains a balanceOf function that takes an argument called _owner of type address and returns balance of type uint.
balanceOf function returns the balances[_owner].


This below contract seems very very fine. But, there is a hidden loop hole in this. That is artithmetic underflow issue.

Say the openzepplin once this contract deployed give us 20 tokens, now if we do a transfer of 21 tokens , underflow happens and the balance of the 
caller will be increased to  a very high number
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Token {

  mapping(address => uint) balances;
  uint public totalSupply;

  constructor(uint _initialSupply) public {
    balances[msg.sender] = totalSupply = _initialSupply;
  }

  function transfer(address _to, uint _value) public returns (bool) {
    require(balances[msg.sender] - _value >= 0);
    balances[msg.sender] -= _value;
    balances[_to] += _value;
    return true;
  }

  function balanceOf(address _owner) public view returns (uint balance) {
    return balances[_owner];
  }
}
