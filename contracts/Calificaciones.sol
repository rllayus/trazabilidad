// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;


contract Calificaciones {
    // ─── Tipos ──────────────────────────────────────────────
    struct Nota {
        uint8 valor;      
        uint64 fecha;     
        address profesor; 
        bool existe;  
    }

    // ─── Estado ─────────────────────────────────────────────
    address public admin;
    uint8 public constant NOTA_MAXIMA = 100;

    mapping(address => bool) public esProfesor;
    string[] public materias;

    // estudiante => idMateria => Nota
    mapping(address => mapping(uint256 => Nota)) private notas;

    // ─── Eventos ──────────────────────────────────────────── que publican en logs
    event ProfesorAgregado(address indexed profesor);
    event ProfesorRemovido(address indexed profesor);
    event MateriaAgregada(uint256 indexed idMateria, string nombre);
    event NotaAsignada(
        address indexed estudiante,
        uint256 indexed idMateria,
        uint8 valor,
        address indexed profesor
    );

    // ─── Errores ────────────────────────────────────────────
    error NoEsAdmin();
    error NoEsProfesor();
    error MateriaInexistente(uint256 idMateria);
    error NotaInvalida(uint8 valor);
    error DireccionInvalida();
    error SinNota(address estudiante, uint256 idMateria);

    // ─── Modificadores ──────────────────────────────────────
    modifier soloAdmin() {
        if (msg.sender != admin) revert NoEsAdmin();
        _;
    }

    modifier soloProfesor() {
        if (!esProfesor[msg.sender]) revert NoEsProfesor();
        _;
    }

    modifier materiaValida(uint256 idMateria) {
        if (idMateria >= materias.length) revert MateriaInexistente(idMateria);
        _;
    }

    

    // ─── Administración ─────────────────────────────────────
    function agregarProfesor(address profesor) external soloAdmin {
        if (profesor == address(0)) revert DireccionInvalida();
        esProfesor[profesor] = true;
        emit ProfesorAgregado(profesor);
    }

    function removerProfesor(address profesor) external soloAdmin {
        esProfesor[profesor] = false;
        emit ProfesorRemovido(profesor);
    }

    function agregarMateria(string calldata nombre) external soloAdmin returns (uint256 idMateria) {
        idMateria = materias.length;
        materias.push(nombre);
        emit MateriaAgregada(idMateria, nombre);
    }

    // ─── Profesores ─────────────────────────────────────────
    function asignarNota(
        address estudiante,
        uint256 idMateria,
        uint8 valor
    ) external soloProfesor materiaValida(idMateria) {
        if (estudiante == address(0)) revert DireccionInvalida();
        if (valor > NOTA_MAXIMA) revert NotaInvalida(valor);

        notas[estudiante][idMateria] = Nota({
            valor: valor,
            fecha: uint64(block.timestamp),
            profesor: msg.sender,
            existe: true
        });

        emit NotaAsignada(estudiante, idMateria, valor, msg.sender);
    }

    // ─── Consultas (gratis) ─────────────────────────────────
    function obtenerNota(
        address estudiante,
        uint256 idMateria
    ) external view materiaValida(idMateria) returns (Nota memory) {
        Nota memory nota = notas[estudiante][idMateria];
        if (!nota.existe) revert SinNota(estudiante, idMateria);
        return nota;
    }

    function cantidadMaterias() external view returns (uint256) {
        return materias.length;
    }

    function promedio(address estudiante) external view returns (uint256) {
        uint256 suma;
        uint256 cantidad;
        for (uint256 i = 0; i < materias.length; i++) {
            Nota storage nota = notas[estudiante][i];
            if (nota.existe) {
                suma += nota.valor;
                cantidad++;
            }
        }
        if (cantidad == 0) return 0;
        return (suma * 100) / cantidad;
    }
}