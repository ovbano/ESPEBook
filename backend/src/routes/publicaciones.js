const { Router } = require("express");
const { check } = require("express-validator");
const { validarJWT } = require("../middlewares/validar-jwt");
const {
  obtenerPublicacionesUsuario,
  guardarPublicacion,
  getPublicacionesEnRadio,
  updatePublicacion,
  likePublicacion,
  guardarListArchivo,
  isPublicacionFinalizada,
  deletePublicacion,
  actualizarDescripcion,
} = require("../controllers/publicaciones");
const { validarCampos } = require("../middlewares/validar-campos");

const { validacionesCrearPublicacion } = require("../middlewares/express-validator");

const router = Router();

router.get("/", validarJWT, obtenerPublicacionesUsuario);

// router.get("/cercanas", validarJWT, getPublicacionesEnRadio);


router.put("/like2/:id", validarJWT, likePublicacion);

router.post("/", [...validacionesCrearPublicacion, validarCampos, validarJWT], guardarPublicacion);

router.put("/:id", validarJWT, updatePublicacion);

router.post("/listaArchivos/:uid/:titulo",validarCampos, guardarListArchivo);

router.put("/like", validarJWT, updatePublicacion);

router.put("/marcar-publicacion-pendiente-false/:publicacionId", validarJWT, isPublicacionFinalizada);

//deletePublicacion
router.delete("/:id", validarJWT, deletePublicacion);


//actualizarDescripcion
router.put("/actualizarDescripcion/:id", validarJWT, actualizarDescripcion);

module.exports = router;
