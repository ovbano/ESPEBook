const { Router } = require('express');
const { check } = require('express-validator');

const { crearUsuario, login, renewToken, olvidoPassword } = require('../controllers/auth');
const { validarCampos } = require('../middlewares/validar-campos');
const { validarJWT } = require('../middlewares/validar-jwt');

const router = Router();



router.post('/new', [
    check('nombre','El nombre es obligatorio').not().isEmpty(),
    check('password','La contraseña es obligatoria').not().isEmpty(),
    check('email','El correo es obligatorio').isEmail(),
    validarCampos
], crearUsuario );

router.post('/', [
    check('password','La contraseña es obligatoria').not().isEmpty(),
    check('email','El correo es obligatorio').isEmail(),
    validarCampos
], login );


router.get('/renew', validarJWT, renewToken );

router.post("/olvido-password", olvidoPassword);


// router.post('/google', googleAuth );
    

module.exports = router;
