// Lo ejecuta: el custodio actual del lote
import { network } from "hardhat";
import { DIRECCION_CONTRATO } from "./config.js";

const ID_LOTE = 1n;
const PARA = "0x..."; // dirección del siguiente actor

const { viem } = await network.connect();
const publicClient = await viem.getPublicClient();
const cafe = await viem.getContractAt("TrazabilidadCafe", DIRECCION_CONTRATO);

const hash = await cafe.write.transferirCustodia([ID_LOTE, PARA]);
await publicClient.waitForTransactionReceipt({ hash });
console.log(`✔ Lote ${ID_LOTE} entregado a ${PARA}`);