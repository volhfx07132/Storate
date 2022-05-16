pragma solidity ^0.8.0;

import "./BEP20.sol";

contract TokenBEP20 is BEP20{
    constructor() payable BEP20("TokenBEP20 ", "TKB", 18, 1000000000000000000000000000)  {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}