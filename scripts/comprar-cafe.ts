import { network } from "hardhat";
import { formatEther, formatUnits } from "viem";

const DIRECCION_TIENDA = "0xB4E8E2A4980aCF4f2d5714C27B51023bF83e2A17"; 
const BOLSAS = 1n;

const { viem } = await network.connect();
const publicClient = await viem.getPublicClient();
const tienda = await viem.getContractAt("TiendaCafe", DIRECCION_TIENDA);

const precio = await tienda.read.precioEthUsd();
const costo = (await tienda.read.costoBolsaEnWei()) * BOLSAS;
console.log(`1 ETH = ${formatUnits(precio, 8)} USD (según Chainlink)`);
console.log(`${BOLSAS} bolsa(s) de 10 USD = ${formatEther(costo)} ETH`);

// 2% extra por si el precio cambia antes de la confirmación; el contrato devuelve el vuelto
const hash = await tienda.write.comprar([BOLSAS], { value: (costo * 102n) / 100n });
await publicClient.waitForTransactionReceipt({ hash });
console.log("✔ Compra realizada");