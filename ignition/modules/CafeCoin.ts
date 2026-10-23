import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { parseEther } from "viem";

export default buildModule("CafeCoinModule", (m) => {
  const dueno = m.getAccount(0);
  const suministroInicial = m.getParameter("suministroInicial", parseEther("1000000")); // 1 millón de CAFE

  const cafeCoin = m.contract("CafeCoin", [dueno, suministroInicial]);
  return { cafeCoin };
});