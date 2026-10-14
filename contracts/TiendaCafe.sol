// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {AggregatorV3Interface} from "./oraculo/AggregatorV3Interface.sol";

contract TiendaCafe {
    AggregatorV3Interface public immutable oraculo;
    address public immutable admin;

    uint256 public constant PRECIO_BOLSA_USD = 10e18;  
    uint256 public constant ANTIGUEDAD_MAXIMA = 3 hours;

    mapping(address => uint256) public bolsasCompradas;

    event Compra(address indexed comprador, uint256 bolsas, uint256 pagadoWei, int256 precioEthUsd);

    error PrecioInvalido();
    error PrecioDesactualizado(uint256 actualizadoHace);
    error PagoInsuficiente(uint256 requerido, uint256 enviado);
    error NoEsAdmin();
    error TransferenciaFallida();

    constructor(address direccionOraculo) {
        oraculo = AggregatorV3Interface(direccionOraculo);
        admin = msg.sender;
    }

    function precioEthUsd() public view returns (int256) {
        (, int256 precio,, uint256 actualizado,) = oraculo.latestRoundData();
        if (precio <= 0) revert PrecioInvalido();
        if (block.timestamp - actualizado > ANTIGUEDAD_MAXIMA) {
            revert PrecioDesactualizado(block.timestamp - actualizado);
        }
        return precio;
    }

    function costoBolsaEnWei() public view returns (uint256) {
        return (PRECIO_BOLSA_USD * 1e8) / uint256(precioEthUsd());
    }

    function comprar(uint256 cantidad) external payable {
        uint256 costo = costoBolsaEnWei() * cantidad;
        if (msg.value < costo) revert PagoInsuficiente(costo, msg.value);

        bolsasCompradas[msg.sender] += cantidad;
        emit Compra(msg.sender, cantidad, costo, precioEthUsd());

        uint256 vuelto = msg.value - costo;
        if (vuelto > 0) {
            (bool ok,) = msg.sender.call{value: vuelto}("");
            if (!ok) revert TransferenciaFallida();
        }
    }

    function retirar() external {
        if (msg.sender != admin) revert NoEsAdmin();
        (bool ok,) = admin.call{value: address(this).balance}("");
        if (!ok) revert TransferenciaFallida();
    }
}