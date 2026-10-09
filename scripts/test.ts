import { network } from "hardhat";
import { formatEther } from "viem";

const { viem } = await network.connect();
const [wallet] = await viem.getWalletClients();
const publicClient = await viem.getPublicClient();

const address = wallet.account.address;
const balance = await publicClient.getBalance({ address });
const chainId = await publicClient.getChainId();

console.log("Chain ID:", chainId, chainId === 11155111 ? "(Sepolia ✔)" : "(NO es Sepolia ✖)");
console.log("Dirección:", address);
console.log("Saldo:", formatEther(balance), "ETH");