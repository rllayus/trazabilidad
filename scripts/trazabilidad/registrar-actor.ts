// Lo ejecuta: Admin
import { network } from "hardhat";
import { DIRECCION_CONTRATO, ROLES } from "./config.js";

const ACTORES = [
    { nombre: "Miguel", direccion: "0xAcDC8FB7FD126712A9466a34703dd4E043A8B771", rol: 1 }, // Productor
    { nombre: "Omar", direccion: "0xF2f3c222cC14613F2cB10A2c395608C3f3F08DBc", rol: 1 }, // Productor
    { nombre: "Fernando", direccion: "0xC57b5a973e2b979ec1df14E6F383AD3732754D94", rol: 2 }, // Procesador
    { nombre: "Gael", direccion: "0xc942AD305F917C2d3b7bA30A1A0ec2efbb6Fe045", rol: 2 }, // Procesador
    { nombre: "Crespo", direccion: "0x45eb16c7664c6429ab88cd4f5d878ee6cb441d51", rol: 3 }, // Transportista
    { nombre: "João", direccion: "0xf5a3e8c62eeb149ae1d63c2e09b22ada63fd713b", rol: 3 }, // Transportista
    { nombre: "Hernan", direccion: "0x8aD7593F729f453907EC92b47A4f095fa42a6Ca3", rol: 4 }, // Tostador
    { nombre: "Ari", direccion: "0x1574E9731C88F3483eBC30fE2D9FD53352678B04", rol: 5 }, // Distribuidor
] as const;

const { viem } = await network.connect();

const publicClient = await viem.getPublicClient();
const cafe = await viem.getContractAt("TrazabilidadCafe", DIRECCION_CONTRATO);

for (const a of ACTORES) {
  if ((await cafe.read.roles([a.direccion])) === a.rol) {
    console.log(`• ${a.nombre} ya es ${ROLES[a.rol]}`);
    continue;
  }
  const hash = await cafe.write.registrarActor([a.direccion, a.rol]);
  await publicClient.waitForTransactionReceipt({ hash });

  console.log(`✔ ${a.nombre} registrado como ${ROLES[a.rol]}`);
}