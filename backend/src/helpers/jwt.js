const jwt = require("jsonwebtoken");

const JWT_KEY = "haJSHdjksh!!1i27@askjdhm2nasa21";

const generarJWT = (uid) => {
  return new Promise((resolve, reject) => {
    const payload = { uid };

    jwt.sign(
      payload,
      JWT_KEY,
      {
        expiresIn: "1y",
      },
      (err, token) => {
        if (err) {
          // no se pudo crear el token
          reject("No se pudo generar el JWT");
        } else {
          // TOKEN!
          resolve(token);
        }
      }
    );
  });
};

const comprobarJWT = (token = "") => {
  try {
    const { uid } = jwt.verify(token, JWT_KEY);

    return [true, uid];
  } catch (error) {
    return [false, null];
  }
};

module.exports = {
  generarJWT,
  comprobarJWT,
};
