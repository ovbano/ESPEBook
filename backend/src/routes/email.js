const { Router } = require('express');
const nodemailer = require("nodemailer");
const SMTPSERVER = "smtp.gmail.com";
const SMTPUSER = "schlrscrt@gmail.com";
const SMTPPASSWORD = "muuvxhakzhmkbwid";

const transporter = nodemailer.createTransport({
    host: SMTPSERVER,
    port: 587,
    secure: false,
    requireTLS: true,
    logger: true,
    debug: true,
    auth: {
        //Tendrías que cambiar estas credenciales
        user: SMTPUSER,
        pass: SMTPPASSWORD,
    },
});

transporter.verify().then((error, success) => {
    if (error) {
        console.log("Errorrrrr", error);
    } else {
        console.log("Ready for send emails");
    }
});

const router = Router();

router.post("/send", async (req, res) => {
    try {
        console.log("body", req.body);
        let mail = {
            from: "noreply@example.com",
            // aqui tendrias que cambiar la direccion del correo final
            to: "ovbano@espe.edu.ec",
            subject: "Hello",
            html: `                   
                   <p><strong>Nombre de remitente:</strong> ${req.body.name}</p>
                   <p><strong>Detalles del contacto</strong></p>
                   <p><strong>Correo: </strong>${req.body.email}</p>
                   <p><strong>Teléfono: </strong>${req.body.telf}</p>
                   <p><strong>Mensaje: </strong>${req.body.mensaje}</p>
                   <p>Este mensaje se ha generado de forma automática, por favor no responder.</p>
                   `,
        }
        await transporter.sendMail(mail, error => {
            if (error) {
                console.log("Error sending", error);
                res.json({ status: "ERROR" })
            } else {
                res.json({ status: "Message Sent" })
            }
        });
        return res.sendStatus(200);
    } catch (e) {
        console.log(e);
        return res.sendStatus(500);
    }
});

//Recuperar para movil
router.post("/recover-password", async (req, res) => {
    try {
        // Comprobar si existe el usuario
        const usuario = await Usuario.findOne({ email: req.body.email });
        if (!usuario) {
            return res.status(400).json({ message: "No existe un usuario con ese correo electrónico" });
        }


        // Obtener los datos del usuario
        const nombreUsuario = usuario.nombre; // Reemplaza 'nombre' con el campo real en tu esquema
        const telefonoUsuario = usuario.telefono; // Reemplaza 'telefono' con el campo real en tu esquema
        const correoUsuario = usuario.email;
           
        let mail = {
            from: "noreply@example.com",
            to: "lacastillo12@espe.edu.ec",
            subject: "Recuperación de contraseña",
            html: `
                <html lang="es">
                <head>
                <style>
                    body {
                        font-family: Arial, sans-serif;
                        background-color: #f5f5f5;
                    }
                    .container {
                        max-width: 600px;
                        margin: 0 auto;
                        padding: 20px;
                        background-color: #ffffff;
                        border: 1px solid #e5e5e5;
                        border-radius: 5px;
                        box-shadow: 0 5px 10px rgba(0, 0, 0, 0.1);
                    }
                    h2 {
                        color: #007acc;
                    }
                    p {
                        font-size: 16px;
                        color: #333;
                    }
                </style>
            </head>
                <body>
                    <div class="container">
                        <h2>Recuperación de contraseña</h2>
                        <p>El usuario ${nombreUsuario} con el correo electrónico ${correoUsuario} ha solicitado una nueva contraseña.</p>
                        <p>Teléfono: ${telefonoUsuario}</p>
                        <p>Por favor, ponte en contacto con el usuario para coordinar la entrega de la nueva contraseña.</p>
                        <p>
                    </div>
                </body>
                </html>
            `,
        };
        
        await transporter.sendMail(mail, error => {
            if (error) {
                console.log("Error sending", error);
                return res.status(500).json({ message: "Error al enviar el correo" });
            } else {
                return res.status(200).json({ message: "Correo enviado con la nueva contraseña" });
            }
        });
    } catch (error) {
        console.error(error);
        return res.status(500).json({ message: "Error interno del servidor" });
    }
});

//Recuperar para web
router.post("/recover-password-web", async (req, res) => {
    try {
        // Comprobar si existe el usuario
        const usuario = await Usuario.findOne({ email: req.body.email });
        if (!usuario) {
            return res.status(400).json({ message: "No existe un usuario con ese correo electrónico" });
        }

        // Validar el atributo 'role' del usuario
        if (usuario.role !== "ADMIN_ROLE") {
            return res.status(403).json({ message: "Solo los usuarios administradores pueden modificar contraseñas" });
        }

        // Obtener los datos del usuario
        const nombreUsuario = usuario.nombre; // Reemplaza 'nombre' con el campo real en tu esquema
        const telefonoUsuario = usuario.telefono; // Reemplaza 'telefono' con el campo real en tu esquema
        const correoUsuario = usuario.email;
           
        let mail = {
            from: "noreply@example.com",
            to: "lacastillo12@espe.edu.ec",
            subject: "Recuperación de contraseña",
            html: `
                <html lang="es">
                <head>
                <style>
                    body {
                        font-family: Arial, sans-serif;
                        background-color: #f5f5f5;
                    }
                    .container {
                        max-width: 600px;
                        margin: 0 auto;
                        padding: 20px;
                        background-color: #ffffff;
                        border: 1px solid #e5e5e5;
                        border-radius: 5px;
                        box-shadow: 0 5px 10px rgba(0, 0, 0, 0.1);
                    }
                    h2 {
                        color: #007acc;
                    }
                    p {
                        font-size: 16px;
                        color: #333;
                    }
                </style>
            </head>
                <body>
                    <div class="container">
                        <h2>Recuperación de contraseña</h2>
                        <p>El usuario ${nombreUsuario} con el correo electrónico ${correoUsuario} ha solicitado una nueva contraseña.</p>
                        <p>Teléfono: ${telefonoUsuario}</p>
                        <p>Por favor, ponte en contacto con el usuario para coordinar la entrega de la nueva contraseña.</p>
                        <p>
                    </div>
                </body>
                </html>
            `,
        };
        
        await transporter.sendMail(mail, error => {
            if (error) {
                console.log("Error sending", error);
                return res.status(500).json({ message: "Error al enviar el correo" });
            } else {
                return res.status(200).json({ message: "Correo enviado con la nueva contraseña" });
            }
        });
    } catch (error) {
        console.error(error);
        return res.status(500).json({ message: "Error interno del servidor" });
    }
});


module.exports = router;