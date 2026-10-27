// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

/// @title Cafeteria
/// @notice Tarjeta de fidelidad con roles: 5 sellos = 1 café gratis.
///         Ejemplo de control de acceso con varios roles.
contract Cafeteria is AccessControl {
    
    // ─── Roles ──────────────────────────────────────────────
    bytes32 public constant GERENTE = keccak256("GERENTE");
    bytes32 public constant BARISTA = keccak256("BARISTA");

    uint256 public constant SELLOS_PARA_PREMIO = 5;

    mapping(address => uint256) public sellos;
    mapping(address => uint256) public cafesCanjeados;
    bool public pausada;

    event SelloOtorgado(address indexed cliente, address indexed por, uint256 total);
    event SellosAnulados(address indexed cliente, address indexed por);
    event CafeCanjeado(address indexed cliente);
    event Pausa(bool pausada, address por);

    error NoAutorizado();
    error SellosInsuficientes(uint256 tiene);
    error CafeteriaPausada();

    /// Permite a quien tenga CUALQUIERA de los dos roles
    modifier soloAlgunRol(bytes32 rol1, bytes32 rol2) {
        if (!hasRole(rol1, msg.sender) && !hasRole(rol2, msg.sender)) revert NoAutorizado();
        _;
    }

    modifier noPausada() {
        if (pausada) revert CafeteriaPausada();
        _;
    }

    constructor(address admin) {
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
    }

    // ─── BARISTA o GERENTE (cualquiera de los dos) ──────────
    function darSello(address cliente) external soloAlgunRol(BARISTA, GERENTE) noPausada {
        sellos[cliente]++;
        emit SelloOtorgado(cliente, msg.sender, sellos[cliente]);
    }

    // ─── Solo GERENTE ───────────────────────────────────────
    function anularSellos(address cliente) external onlyRole(GERENTE) {
        sellos[cliente] = 0;
        emit SellosAnulados(cliente, msg.sender);
    }

    // ─── GERENTE o ADMIN ────────────────────────────────────
    function pausar(bool valor) external soloAlgunRol(GERENTE, DEFAULT_ADMIN_ROLE) {
        pausada = valor;
        emit Pausa(valor, msg.sender);
    }

    // ─── Cualquier cliente (sin rol) ────────────────────────
    function canjear() external noPausada {
        if (sellos[msg.sender] < SELLOS_PARA_PREMIO) revert SellosInsuficientes(sellos[msg.sender]);
        sellos[msg.sender] -= SELLOS_PARA_PREMIO;
        cafesCanjeados[msg.sender]++;
        emit CafeCanjeado(msg.sender);
    }
}