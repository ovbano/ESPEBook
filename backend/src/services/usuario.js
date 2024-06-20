const Usuario = require('../models/usuario');

class UsuarioService {

    async guardarUsuario(usuario = new Usuario()) {
        try {
            var usuarioGuardado;
            await Usuario.create(usuario).then( (value) => {
                usuarioGuardado =  value;
            });

            return usuarioGuardado;

        } catch (error) {
            console.log(error);

        }
    }

    async getUsuarios(desde, uid) {
        return await Usuario.find({ _id: { $ne: uid } })
            .sort('-online')
            .skip(desde)
            .limit(20);
    }

    async actualizarUsuario(uid, data) {
        return await Usuario.findByIdAndUpdate(uid, data, { new: true });
    }

    async actualizarIsOpenRoom(uid, isOpenRoom) {
        return await Usuario.findByIdAndUpdate(uid, { isOpenRoom }, { new: true });
    }

    async actualizarTelefonoOrNombre(uid, nombre, telefono) {
        return await Usuario.findByIdAndUpdate(uid, { nombre, telefono }, { new: true });
    }

    async agregarDireccion(idUsuario, direccion) {
        const usuario = await Usuario.findById(idUsuario);
        if (usuario) {
            usuario.direcciones.push(direccion);
            await usuario.save();
        }
        return usuario;
    }

    async agregarTelefono(idUsuario, telefono) {
        const usuario = await Usuario.findById(idUsuario);
        if (usuario && !usuario.telefonos.includes(telefono)) {
            usuario.telefonos.push(telefono);
            await usuario.save();
        }
        return usuario;
    }

    async eliminarTelefono(idUsuario, telefono) {
        const usuario = await Usuario.findById(idUsuario);
        if (usuario && usuario.telefonos.includes(telefono)) {
            usuario.telefonos = usuario.telefonos.filter(tel => tel !== telefono);
            await usuario.save();
        }
        return usuario;
    }

    async enviarNotificacionesArrayTelefonos(idUsuario, lat, lng) {
        const usuario = await Usuario.findById(idUsuario).populate('ubicaciones', 'latitud longitud');
        const tokens = (await Usuario.find({ telefono: { $in: usuario.telefonos } })).map(u => u.tokenApp);
        const data = {
            nombre: usuario.nombre,
            latitud: lat,
            longitud: lng,
            img: usuario.img,
            google: usuario.google,
            type: 'sos',
        };
        // Llamada a los métodos de envío de notificación y guardado de notificación
        // await enviarNotificacion(tokens, `${usuario.nombre} necesita ayuda`, "Presiona para ver la ubicación", data);
        // Guardado de notificaciones SOS en los usuarios destino
        return tokens;
    }

    async marcarPublicacionPendienteFalse(idUsuario) {
        return await Usuario.findByIdAndUpdate(idUsuario, { isPublicacionPendiente: false }, { new: true });
    }

    async marcarSalaPendienteFalse(idUsuario) {
        return await Usuario.findByIdAndUpdate(idUsuario, { isSalasPendiente: false }, { new: true });
    }

    async marcarNotificacionesPendienteFalse(idUsuario) {
        return await Usuario.findByIdAndUpdate(idUsuario, { isNotificacionesPendiente: false }, { new: true });
    }

    async eliminarTokenApp(uid) {
        return await Usuario.findByIdAndUpdate(uid, { $unset: { tokenApp: "" } }, { new: true });
    }
}

module.exports = new UsuarioService();
