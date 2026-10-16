import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
const ORACULO_ETH_USD_SEPOLIA = "0x4b046Db3FB5800114281F5d6b9DfD7F1293B6A62";
export default buildModule("BodegaCafeModule", (m) => {
  const contrato = m.contract("BodegaCafe", [ORACULO_ETH_USD_SEPOLIA]);

  return { contrato };
});