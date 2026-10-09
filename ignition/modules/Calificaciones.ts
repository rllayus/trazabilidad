import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("CalificacionesModule", (m) => {
  const contrato = m.contract("Calificaciones");

  const cert = m.call(contrato, "agregarMateria", ["certificacionIV"], { id: "CertIV" });
  const patrones = m.call(contrato, "agregarMateria", ["PatronesDiseño"], { id: "PatronI", after: [cert] });
  const baseDatos = m.call(contrato, "agregarMateria", ["Base de Datos "], { id: "BaseDatos", after: [patrones] });

  const profesor = m.call(contrato, "agregarProfesor", ["0xA1849Ba72149563Bafb4D6A17BEAA0d8b930Ca93"], { id: "Profesor"});

  return { contrato };
});
