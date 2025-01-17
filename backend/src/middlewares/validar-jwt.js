const jwt = require("jsonwebtoken");

const JWT_KEY = "haJSHdjksh!!1i27@askjdhm2nasa21";

const validarJWT = (req, res, next) => {
  // Leer token
  const token = req.header("x-token");

  if (!token) {
    return res.status(401).json({
      ok: false,
      msg: "No hay token en la petición",
    });
  }

  try {
    const { uid } = jwt.verify(token, JWT_KEY);
    console.log(uid);
    req.uid = uid;

    next();
  } catch (error) {
    return res.status(401).json({
      ok: false,
      msg: "Token no válido",
    });
  }
};

module.exports = {
  validarJWT,
};
