const { response } = require("express");
const bcrypt = require("bcryptjs");

const Usuario = require("../models/usuario");
const { generarJWT } = require("../helpers/jwt");
const { validarGoogleIdToken } = require("../helpers/google-verify-token");

const crearUsuario = async (req, res = response) => {
  const { email, password, tokenApp } = req.body;

  try {
    const existeEmail = await Usuario.findOne({ email });
    if (existeEmail) {
      return res.status(400).json({
        ok: false,
        msg: "El correo ya está registrado",
      });
    }

    const usuario = new Usuario(req.body);

    // Encriptar contraseña
    const salt = bcrypt.genSaltSync();
    usuario.password = bcrypt.hashSync(password, salt);
    usuario.tokenApp = tokenApp;
    await usuario.save();

    // Generar mi JWT
    const token = await generarJWT(usuario.id);

    res.json({
      ok: true,
      usuario,
      token,
    });
  } catch (error) {
    console.log(error);
    res.status(500).json({
      ok: false,
      msg: "Hable con el administrador",
    });
  }
};
const login = async (req, res = response) => {
  const { email, password, tokenApp } = req.body;


  try {
    const usuarioDB = await Usuario.findOne({ email });
    if (!usuarioDB) {
      return res.status(404).json({
        ok: false,
        msg: "Email no encontrado",
      });
    }

    // Validar el password
    const validPassword = bcrypt.compareSync(password, usuarioDB.password);
    if (!validPassword) {
      return res.status(400).json({
        ok: false,
        msg: "La contraseña no es valida",
      });
    }

    // Actualizar el token de dispositivo si se proporciona
    if (tokenApp) {
      await Usuario.findOneAndUpdate({ email }, { tokenApp });//b
    }

    // Generar el JWT
    const token = await generarJWT(usuarioDB.id);

    res.json({
      ok: true,
      usuario: usuarioDB,
      token,
    });
  } catch (error) {
    console.log(error);
    return res.status(500).json({
      ok: false,
      msg: "Hable con el administrador",
    });
  }
};


const renewToken = async (req, res = response) => {
  try {
    const uid = req.uid;

    // Generar un nuevo JWT usando el UID del usuario
    const token = await generarJWT(uid);

    // Obtener el usuario por el UID desde la base de datos
    const usuarioDB = await Usuario.findById(uid).populate(
      "ubicaciones",
      "latitud longitud ciudad pais barrio updatedAt createdAt estado _id"
    );

    if (!usuarioDB) {
      return res.status(404).json({
        ok: false,
        msg: "Usuario no encontrado",
      });
    }

    // Obtener el token de dispositivo (tokenApp) desde la solicitud
    const { tokenApp } = req.body;

    // Actualizar el token de dispositivo si se proporciona en la solicitud
    if (tokenApp) {
      usuarioDB.tokenApp = tokenApp;
      await usuarioDB.save();
    }

    // Devolver la respuesta con el nuevo token JWT y los datos del usuario
    res.json({
      ok: true,
      usuario: usuarioDB,
      token,
    });
  } catch (error) {
    console.log(error);
    return res.status(500).json({
      ok: false,
      msg: "Hable con el administrador",
    });
  }
};

const olvidoPassword = async (req, res) => {
  const { email, nuevaContrasena } = req.body;
  console.log(req.body);
  try {
    // Verificar si el usuario con el correo proporcionado existe
    const usuario = await Usuario.findOne({ email });

    if (!usuario) {
      return res.status(404).json({
        ok: false,
        msg: "Usuario no encontrado",
      });
    }

    // Cambiar la contraseña del usuario
    const salt = bcrypt.genSaltSync();
    usuario.password = bcrypt.hashSync(nuevaContrasena, salt);
    await usuario.save();

    return res.json({
      ok: true,
      msg: "Contraseña cambiada exitosamente",
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      ok: false,
      msg: "Hable con el administrador",
    });
  }
};



module.exports = {
  crearUsuario,
  login,
  renewToken,
  olvidoPassword,
};
