import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("TrazabilidadCafeModule", (m) => {
  const contrato = m.contract("TrazabilidadCafe");

  return { contrato };
});