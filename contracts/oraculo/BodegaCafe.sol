//SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {TemperaturaInterface} from "./TemperaturaInterface.sol";

contract BodegaCafe {
    TemperaturaInterface public oraculo;

    constructor(address _oraculo) {
        oraculo = TemperaturaInterface(_oraculo);
    }

     function estado() external view returns (string memory) {
         (int256 temperatura,) = oraculo.temperaturaActual();

        if (temperatura > 250) return "Muy caliente: el cafe se deteriora";
        if (temperatura < 100  ) return "Muy frio: riesgo de humedad";
        return "Temperatura ideal";
    }
}