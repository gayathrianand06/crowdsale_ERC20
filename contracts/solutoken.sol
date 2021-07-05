pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/token/MintableToken.sol';

contract HashnodeToken is MintableToken {
  string public name = "SoluToken";
  string public symbol = "ST";
  uint8 public decimals = 18;
  uint256 public totalSupply = 100000000;
}
