pragma solidity =0.5.15;

import "../AliumERC20.sol";

contract ERC20 is AliumERC20 {
    constructor(uint256 _totalSupply) public {
        _mint(msg.sender, _totalSupply);
    }
}
