// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {TipoCambioInterface} from "./oraculo/TipoCambioInterface.sol";

contract TipoCambioOraculo is TipoCambioInterface {
    address public admin;
    int256 private tipoCambioAux;   
    uint256 private actualizado; 

    int256 public constant MINIMO = 0; // valor mínimo permitido
    //uint256 public constant MAXIMO = 10000;  // valor máximo permitido

    event TipoCambioActualizado(int256 decimasMoneda, uint256 actualizado);
    event AdminCambiado(address anterior, address nuevo);

    error NoEsAdmin();
    error FueraDeRango(int256 valor);
    error SinDatos();

    modifier soloAdmin() {
        if (msg.sender != admin) revert NoEsAdmin();
        _;
    }

    constructor() {
        admin = msg.sender;
        tipoCambioAux = 694; // valor inicial de ejemplo
        actualizado = block.timestamp;
    }

    function actualizarTipoCambio(int256 decimasMoneda) external soloAdmin {
        if (decimasMoneda < MINIMO) revert FueraDeRango(decimasMoneda);
        tipoCambioAux = decimasMoneda;
        actualizado = block.timestamp;
        emit TipoCambioActualizado(decimasMoneda, block.timestamp);
    }

    function tipoCambio() external view override returns (int256 , uint256) {
        if (actualizado == 0) revert SinDatos();
        return (tipoCambioAux, actualizado);
    }
}