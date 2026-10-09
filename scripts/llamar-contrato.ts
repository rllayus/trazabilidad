import { network } from "hardhat";

const { viem } = await network.connect();

const counter = await viem.getContractAt(
  "Counter",
  //"0x610178dA211FEF7D417bC0e6FeD39F05609AD788" // tu dirección
  //"0x79CdeCD3A6E6De5c2F6170662EE9421506d314bB"
  "0xe5990000dc82669B5839D817A6fa8DC81bCB6C2e"
);

console.log("Valor inicial: ", await counter.read.x());

await counter.write.inc();   // Llama al método que incrementa en 1
//await counter.write.incBy([10000000n]); // llama al método que incrementa en 10

console.log("Valor final:", await counter.read.x());