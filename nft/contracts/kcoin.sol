// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract KCoin is ERC20 {
    address owner;
    
    constructor() ERC20("KCoin","KC"){
        owner = msg.sender;
        _mint(msg.sender, 1e18);
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "Only owner");
        _;
    }

    function mint(address receiver, uint amount) public onlyOwner {
        _mint(receiver, amount);
    }
}