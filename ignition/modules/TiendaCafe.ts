import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

// dirección del oráculo de Chainlink ETH/USD en la red Sepolia
const ORACULO_ETH_USD_SEPOLIA = "0x694AA1769357215DE4FAC081bf1f309aDC325306";

export default buildModule("TiendaModule", (m) => {
  const tienda = m.contract("TiendaCafe", [ORACULO_ETH_USD_SEPOLIA]);
  return { tienda };
});