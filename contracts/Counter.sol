// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.34;

contract Counter {
  uint public x; // Valor que se guardará en el contrato

  event Increment(uint by);

  function inc() public {
    x = 1;
    emit Increment(1);
  }

  function incBy(uint by) public {
    require(by > 0, "Debe ser un valor positivo");
    x *= by;
    emit Increment(by);
  }
}
