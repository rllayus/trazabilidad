// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

/// @title ContadorV1 - primera versión de la lógica
contract ContadorV1 is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    uint256 public x;

    event Incremento(uint256 cantidad);

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers(); // nadie puede inicializar la implementación directamente
    }

    /// Reemplaza al constructor: se ejecuta una sola vez, a través del proxy
    function initialize(address owner) public initializer {
        __Ownable_init(owner);
    }

    function inc() external {
        x++;
        emit Incremento(1);
    }

    function version() external pure returns (string memory) {
        return "V1";
    }

    /// Solo el owner puede cambiar la implementación
    function _authorizeUpgrade(address) internal override onlyOwner {}
}