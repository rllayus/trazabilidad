import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

// Despliega la implementación V1 y el proxy que apunta a ella
export default buildModule("ContadorProxyModule", (m) => {
  const owner = m.getAccount(0);

  const implV1 = m.contract("ContadorV1");

  // Codifica la llamada initialize(owner) para ejecutarla al crear el proxy
  const datosInit = m.encodeFunctionCall(implV1, "initialize", [owner]);

  const proxy = m.contract("ContadorProxy", [implV1, datosInit]);

  // El mismo proxy, visto con el ABI de V1
  const contador = m.contractAt("ContadorV1", proxy, { id: "ContadorV1EnProxy" });

  return { proxy, contador };
});