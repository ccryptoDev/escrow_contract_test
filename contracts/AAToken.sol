//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AAToken is ERC20, Ownable {
    uint256 public tokenTotalSupply = 100 * 10**18;

    constructor() ERC20("AA", "AA") {
        _mint(msg.sender, tokenTotalSupply);
    }
}
