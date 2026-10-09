import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("FacturacionModule", (m) => {
  const contrato = m.contract("Facturacion");

  return { contrato };
});