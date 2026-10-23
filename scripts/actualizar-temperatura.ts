import { network } from "hardhat";

const DIRECCION_ORACULO = "0x4b046Db3FB5800114281F5d6b9DfD7F1293B6A62";  

const TEMPERATURA =  300n;

const { viem } = await network.connect();
const publicClient = await viem.getPublicClient();
const [yo] = await viem.getWalletClients();

const oraculo = await viem.getContractAt("TemperaturaOraculo", DIRECCION_ORACULO);

const hash = await oraculo.write.actualizarTemperatura([TEMPERATURA]);
await publicClient.waitForTransactionReceipt({ hash });
console.log("✔ Temperatura actualizada");
