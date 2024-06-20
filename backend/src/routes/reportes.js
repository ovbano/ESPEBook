const { Router } = require("express");
const {
  obtenerCiudades,obtenerBarrios,obtenerEmergencias,obtenerReporteBarras,obtenerReportePastel,obtenerAnios,obtenerMapaCalor,obtenerDatosCards
  ,obtenerCoordenadas
  ,descargarXLSX,descargarPDF,descargarCSV
} = require("../controllers/reportes");

const { validarJWT } = require("../middlewares/validar-jwt");

const router = Router();
router.get(
  "/obtenerCiudades",
  /* validarJWT, */
  obtenerCiudades
);
router.post(
  "/obtenerBarrios",
/*   validarJWT, */
  obtenerBarrios
);
router.post(
  "/obtenerEmergencias",
/*   validarJWT, */
  obtenerEmergencias
);
router.post(
  "/obtenerReporteBarras",
/*   validarJWT, */
  obtenerReporteBarras
);
router.post(
  "/obtenerReportePastel",
/*   validarJWT, */
obtenerReportePastel
);
router.post(
  "/obtenerAnios",
/*   validarJWT, */
obtenerAnios
);
router.post(
  "/obtenerMapaCalor",
/*   validarJWT, */
obtenerMapaCalor
);
router.get(
  "/obtenerDatosCards",
/*   validarJWT, */
obtenerDatosCards
);

router.post(
  "/obtenerCoordenadas",
/*   validarJWT, */
obtenerCoordenadas
);

router.post(
  "/descargarXLSX",
/*   validarJWT, */
descargarXLSX
);

router.post(
  "/descargarPDF",
/*   validarJWT, */
descargarPDF
);

router.post(
  "/descargarCSV",
/*   validarJWT, */
descargarCSV
);

module.exports = router;
