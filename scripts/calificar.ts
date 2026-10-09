import { getAddress } from "viem";
import { network } from "hardhat";

const DIRECCION_CONTRATO = "0x885cAB24EDFA93827118C58c260d44e06768e232"; // dirección del contrato desplegado

const PROFESORES_A_AGREGAR: `0x${string}`[] = [
   "0xA1849Ba72149563Bafb4D6A17BEAA0d8b930Ca93",
];


// Direcciones de los estudiantes
const ESTUDIANTES = {
  estudiante: "0xc942AD305F917C2d3b7bA30A1A0ec2efbb6Fe045",
  fernando: "0xb4D77F48be6f06cCC15f063d3E2d480a0efFF3d7",
  gael: "0xc942AD305F917C2d3b7bA30A1A0ec2efbb6Fe045",
  omar: "0xB4C9F592eE84A20E7291Ae07e7d3656118967BE5",
  hernan: "0x8aD7593F729f453907EC92b47A4f095fa42a6Ca3",
  jose: "0x387aF3DDCed6F26BB85007e34AD1E5e4A9a40a74"

} as const;

// Materias: 0 = ceritificacion, 1 = patrones, 2 = base de datos
const NOTAS = [
  //{ estudiante: ESTUDIANTES.estudiante, materia: 1n, valor: 95 },
  { estudiante: ESTUDIANTES.fernando, materia: 0n, valor: 90 },
  { estudiante: ESTUDIANTES.gael, materia: 0n, valor: 90 },
  { estudiante: ESTUDIANTES.omar, materia: 0n, valor: 90 },
  { estudiante: ESTUDIANTES.hernan, materia: 0n, valor: 90 },
  { estudiante: ESTUDIANTES.jose, materia: 1n, valor: 90 },
];

// ─── Conexión ───────────────────────────────────────────
const { viem } = await network.connect();
const publicClient = await viem.getPublicClient();

const [admin, profesor] = await viem.getWalletClients();

const contrato = await viem.getContractAt("Calificaciones", DIRECCION_CONTRATO);

async function enviar(descripcion: string, tx: Promise<`0x${string}`>) {
  const hash = await tx;
  await publicClient.waitForTransactionReceipt({ hash });
  console.log(`✔ ${descripcion}`);
}

// ─── 0. Verificar que la cuenta 0 es el admin ───────────
const adminDelContrato = await contrato.read.admin();
if (getAddress(adminDelContrato) !== getAddress(admin.account.address)) {
  throw new Error(
    `La cuenta ${admin.account.address} no es el admin. El admin es ${adminDelContrato}`,
  );
}

// ─── 1. Agregar profesores ──────────────────────────────
const profesores = [profesor.account.address, ...PROFESORES_A_AGREGAR];

for (const p of profesores) {
  if (!(await contrato.read.esProfesor([p]))) {
    await enviar(`Profesor agregado: ${p}`,
      contrato.write.agregarProfesor([p], { account: admin.account }));
  } else {
    console.log(`• Ya es profesor: ${p}`);
  }
}

// ─── 3. Asignar notas (las firma el profesor) ───────────
for (const { estudiante, materia, valor } of NOTAS) {
  await enviar(`Nota ${valor} → ${estudiante} (materia ${materia})`,
    contrato.write.asignarNota([estudiante, materia, valor], { account: profesor.account }));
}

