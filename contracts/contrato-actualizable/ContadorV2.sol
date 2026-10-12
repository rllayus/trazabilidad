// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

/// @title ContadorV2 - nueva lógica, mismo almacenamiento + variables nuevas al final
contract ContadorV2 is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    // ⚠ Variables de V1: mismo orden y mismo tipo. NO tocar.
    uint256 public x;

    // ✔ Variables nuevas: SIEMPRE al final
    uint256 public totalOperaciones;

    event Incremento(uint256 cantidad);
    event Decremento(uint256 cantidad);

    error NoPuedeSerNegativo();

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address owner) public initializer {
        __Ownable_init(owner);
    }

    function inc() external {
        x++;
        totalOperaciones++;
        emit Incremento(1);
    }

    // Función nueva en V2
    function incBy(uint256 cantidad) external {
        x += cantidad;
        totalOperaciones++;
        emit Incremento(cantidad);
    }

    // Función nueva en V2
    function dec() external {
        if (x == 0) revert NoPuedeSerNegativo();
        x--;
        totalOperaciones++;
        emit Decremento(1);
    }

    function version() external pure returns (string memory) {
        return "V2";
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}
}