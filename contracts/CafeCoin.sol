// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @title CafeCoin (CAFE)
/// @notice Token ERC-20 de la cafetería: el dueño emite monedas y cualquiera puede quemar las suyas.
contract CafeCoin is ERC20, ERC20Burnable, Ownable {
    uint256 public constant SUMINISTRO_MAXIMO = 10_000_000 * 1e18; // 10 millones de CAFE

    error SuministroMaximoExcedido(uint256 disponible);

    constructor(address dueno, uint256 suministroInicial) ERC20("Cafe Coin", "CAFE") Ownable(dueno) {
        _emitir(dueno, suministroInicial);
    }

    /// Solo el dueño puede crear nuevas monedas (ej. para premiar clientes)
    function emitir(address destino, uint256 monto) external onlyOwner {
        _emitir(destino, monto);
    }

    function _emitir(address destino, uint256 monto) private {
        uint256 disponible = SUMINISTRO_MAXIMO - totalSupply();
        if (monto > disponible) revert SuministroMaximoExcedido(disponible);
        _mint(destino, monto);
    }
}