// Lo ejecuta: el custodio actual del lote (Procesador, Transportista, Tostador o Distribuidor)
import { network } from "hardhat";
import { DIRECCION_CONTRATO, ETAPAS } from "./config.js";

const ID_LOTE = 1n;
const DETALLE = "Lavado y secado al sol";

const { viem } = await network.connect();
const publicClient = await viem.getPublicClient();
const cafe = await viem.getContractAt("TrazabilidadCafe", DIRECCION_CONTRATO);


const hash = await cafe.write.avanzarEtapa([ID_LOTE, DETALLE]);
await publicClient.waitForTransactionReceipt({ hash });

const lote = await cafe.read.obtenerLote([ID_LOTE]);
console.log(`✔ Lote ${ID_LOTE} ahora está en etapa: ${ETAPAS[lote.etapa]}`);