import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("CafeteriaModule", (m) => {
  const admin = m.getAccount(0);
  const cafeteria = m.contract("Cafeteria", [admin]);
  return { cafeteria };
});