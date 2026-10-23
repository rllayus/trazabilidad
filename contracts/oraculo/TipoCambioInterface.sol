// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface TipoCambioInterface {
    function tipoCambio() external view returns (int256 tipoCambio, uint256 actualizado);
}