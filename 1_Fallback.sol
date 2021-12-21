/*
To beat this level 

We need to claim ownership of the contract
Reduce the contract's balance to 0.

Explanation :

This contract is called as Fallback contract and , it's importing openzeppelin's safemath library for arithmetic operations.
contract has a mapping to store the amount of contributions done by the ETH addresses. This is a public mapping and it automatically gets a getter
contact has a varibale called owner which is payable and is public. Public variables by default  gets a getter function with the same name.
Contract has a constructor that's deployed only once and all the initialization code should be inside the constructor.

constructor in the below code sets 

`owner = msg.sender` -- which means the state variable owner is assigned to the address that's deploying the smart contract.
updating contributions value for the contract owner address to `1000 * (1 * ether)`

Next in the contract we have a modifier function called onlyOwner that allows the owner of the contract to execute any function 
that has this modifier applied.

contract has a function called contribute that's public and is a payable function. Payable functions basically accepts ether via the msg.value
Contribute function checks for the msg.value which is the value of ETH that is being sent to the contract and the checks enforces the value should
be less than 0.001 ether. Once the function is called this check happens and if the check is passed then the contributions for the caller's address is
added with the msg.value. Then there is a condition which says if the contributions of the msg.sender are greater than the owner of the contract
then the function caller (msg.sender) can be the owner of the address. That's exactly what we need to win the game.

But that's a very expensive way to way as we have to contribute more than 1000 Ether. And with 0.001 as the limit we need do many transactions which we don't want.


Contract has  getContribution function which is public and view. This just reads the data from blockchain and it get the amount of contributions 
made by the particular caller's address of the function

contract has a withdraw function, which transfer the balance of the contract to the caller. But it is guarded by onlyOwner modifier. In order
for us to withdraw all the funds we should become owner.

Finally, contract has this fallback function which just checks the msg.value is greater than zero and contributions are >0, once this check is pased
the owner state variable is assigned to the msg.sender. 
 
 That's loop hole in the contract and we should do the following to pass the check in the fallback function become owner and then we can withdraw the amount
 from the contract.

---------------------------------------------------SOLUTION----------------------------------------------------------
// send value to the contract using the below commands to become owner

await contract.contrbute({value: 1})
await contract.sendTransaction({value: 1})

These two satisifes the checks in the fall back and make the caller's address as owner.

// To withdraw the funds from the contract

await contract.withdraw()

---------------------------------------------****************------------------------------------------------------


*/


// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import '@openzeppelin/contracts/math/SafeMath.sol';

contract Fallback {

  using SafeMath for uint256;
  mapping(address => uint) public contributions;
  address payable public owner;

  constructor() public {
    owner = msg.sender;
    contributions[msg.sender] = 1000 * (1 ether);
  }

  modifier onlyOwner {
        require(
            msg.sender == owner,
            "caller is not the owner"
        );
        _;
    }

  function contribute() public payable {
    require(msg.value < 0.001 ether);
    contributions[msg.sender] += msg.value;
    if(contributions[msg.sender] > contributions[owner]) {
      owner = msg.sender;
    }
  }

  function getContribution() public view returns (uint) {
    return contributions[msg.sender];
  }

  function withdraw() public onlyOwner {
    owner.transfer(address(this).balance);
  }

  receive() external payable {
    require(msg.value > 0 && contributions[msg.sender] > 0);
    owner = msg.sender;
  }
}


