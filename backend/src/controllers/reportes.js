// const {
//   Publicacion,
//   Usuario
// } = require("../models");

const Publicacion = require("../models/publicacion");
const Usuario = require("../models/usuario");
const fs = require('fs');
//const moment = require('moment-timezone');
const PDFDocument = require('pdfkit');
const pdfMakePrinter = require('pdfmake/src/printer');
const pdfMakeUni = require('pdfmake-unicode');
const ExcelJS = require('exceljs');
const publicacion = require("../models/publicacion");

//Importaciones
const pdf = require("html-pdf");
const pdfTemplate = require("../prueba/public/pdfTemplate");
const path = require("path");


const obtenerCiudades = async (req, res) => {
  let ciudades = [];
  try {
    let publicaciones = await Publicacion.find();
    ciudades = Array.from(new Set(publicaciones.map(publicacion => publicacion['ciudad'])));

    res.json({
      ok: true,
      msg: "Ciudades obtenidas correctamente",
      data: ciudades
    });

  } catch (error) {
    console.log(error);
    res.status(500).json({
      ok: false,
      msg: "Por favor hable con el administrador",
    });
  }
};

const obtenerUnidadesEducativas = async (req, res) => {
  let unidadesEducativas = [];
  let unidadEducativa = req.query.unidadEducativa;
  console.log("unidadEducativa");
  console.log(unidadEducativa);
  let publicaciones = [];
  try {
    // if (unidadEducativa == "" || unidadEducativa === undefined){
    //   publicaciones = await Publicacion.find();
    // }else {
    //   publicaciones = await Publicacion.find({ unidadEducativa });
    // }
    publicaciones = await Publicacion.find();
    unidadesEducativas = Array.from(
      new Set(publicaciones.map((publicacion) => publicacion["unidadEducativa"]))
    );

    res.json({
      ok: true,
      msg: "Unidades Educativas obtenidas correctamente",
      data: unidadesEducativas,
    });
  } catch (error) {
    console.log(error);
    res.status(500).json({
      ok: false,
      msg: "Por favor hable con el administrador",
    });
  }
};

const obtenerBarrios = async (req, res) => {
  let barrios = [];
  let consulta = {};
  try {
    const parametrosBusqueda = req.body;
    Object.keys(parametrosBusqueda).forEach(key => {
      if (parametrosBusqueda[key] !== '' && parametrosBusqueda[key] !== undefined) {
        consulta[key] = parametrosBusqueda[key];
      }
    });
    let publicaciones = await Publicacion.find(consulta);
    if (parametrosBusqueda.horaFin != undefined && parametrosBusqueda.horaFin.includes(':')) {
      const FechahoraFin = convertToEcuadorTimeZone(new Date(parametrosBusqueda.horaFin));
      const horaFin = FechahoraFin.getHours();
      const minutosFin = FechahoraFin.getMinutes();
      const documentosHoraFin = publicaciones.filter((publicacion) => {
        const hora = publicacion.createdAt.getHours();
        const minutos = publicacion.createdAt.getMinutes();

        return (hora < horaFin || (hora === horaFin && minutos <= minutosFin));
      });
      publicaciones = documentosHoraFin
    }

    if (parametrosBusqueda.horaInicio != undefined && parametrosBusqueda.horaInicio.includes(':')) {
      const FechahoraInicio = convertToEcuadorTimeZone(new Date(parametrosBusqueda.horaInicio));
      const horaInicio = FechahoraInicio.getHours();
      const minutosInicio = FechahoraInicio.getMinutes();
      const documentosHoraInicio = publicaciones.filter((publicacion) => {
        const hora = publicacion.createdAt.getHours();
        const minutos = publicacion.createdAt.getMinutes();
        return (hora > horaInicio || (hora === horaInicio && minutos >= minutosInicio));
      });
      publicaciones = documentosHoraInicio
    }


    barrios = Array.from(new Set(publicaciones.map(publicacion => publicacion['barrio'])));
    res.json({
      ok: true,
      msg: "Barrios obtenidos correctamente",
      data: barrios
    });
  } catch (error) {
    console.log(error);
    res.status(500).json({
      ok: false,
      msg: "Por favor hable con el administrador",
    });
  }
}

const obtenerDatosCards = async (req, res) => {
  let publicacionesRegistradas = 0;
  let usuariosRegistros = 0;
  let publicacionesDelMes = 0;
  let publicacionesDelDia = 0;
  try {
    let publicaciones = await Publicacion.find();
    const usuarios = await Usuario.find();
    publicacionesRegistradas = publicaciones.length;
    usuariosRegistros = usuarios.length;
    const fechaActual = new Date();

    // Calcula el primer día del mes actual
    const primerDiaMesActual = new Date(fechaActual.getFullYear(), fechaActual.getMonth(), 1);

    // Calcula el último día del mes actual
    const ultimoDiaMesActual = new Date(fechaActual.getFullYear(), fechaActual.getMonth() + 1, 0);

    // Consulta las publicaciones que se encuentran dentro del rango del mes actual
    publicacionesDelMes = await Publicacion.countDocuments({
      createdAt: {
        $gte: primerDiaMesActual,
        $lte: ultimoDiaMesActual
      },
    });

    const fechaInicioDiaActual = new Date();
    fechaInicioDiaActual.setHours(0, 0, 0, 0);

    // Obtenemos la fecha de fin del día actual
    const fechaFinDiaActual = new Date();
    fechaFinDiaActual.setHours(23, 59, 59, 999);

    // Realizamos la consulta a la base de datos para obtener el conteo
    publicacionesDelDia = await Publicacion.countDocuments({
      createdAt: {
        $gte: fechaInicioDiaActual,
        $lte: fechaFinDiaActual,
      },
    });
    res.json({
      ok: true,
      msg: "Barrios obtenidos correctamente",
      data: {
        publicacionesRegistradas,
        usuariosRegistros,
        publicacionesDelMes,
        publicacionesDelDia
      }
    });
  } catch (error) {
    console.log(error);
    res.status(500).json({
      ok: false,
      msg: "Por favor hable con el administrador",
    });
  }
}

const obtenerAnios = async (req, res) => {
  let anios = [];
  let consulta = {};
  try {
    const parametrosBusqueda = req.body;
    Object.keys(parametrosBusqueda).forEach(key => {
      if (parametrosBusqueda[key] != '') {
        consulta[key] = parametrosBusqueda[key];
      }
    });
    let publicaciones = await Publicacion.find(consulta);
    if (parametrosBusqueda.horaFin != undefined && parametrosBusqueda.horaFin.includes(':')) {
      const FechahoraFin = convertToEcuadorTimeZone(new Date(parametrosBusqueda.horaFin));
      const horaFin = FechahoraFin.getHours();
      const minutosFin = FechahoraFin.getMinutes();
      const documentosHoraFin = publicaciones.filter((publicacion) => {
        const hora = publicacion.createdAt.getHours();
        const minutos = publicacion.createdAt.getMinutes();

        return (hora < horaFin || (hora === horaFin && minutos <= minutosFin));
      });
      publicaciones = documentosHoraFin
    }

    if (parametrosBusqueda.horaInicio != undefined && parametrosBusqueda.horaInicio.includes(':')) {
      const FechahoraInicio = convertToEcuadorTimeZone(new Date(parametrosBusqueda.horaInicio));
      const horaInicio = FechahoraInicio.getHours();
      const minutosInicio = FechahoraInicio.getMinutes();
      const documentosHoraInicio = publicaciones.filter((publicacion) => {
        const hora = publicacion.createdAt.getHours();
        const minutos = publicacion.createdAt.getMinutes();
        return (hora > horaInicio || (hora === horaInicio && minutos >= minutosInicio));
      });
      publicaciones = documentosHoraInicio
    }


    anios = Array.from(new Set(publicaciones.map(publicacion => new Date(publicacion.createdAt).getFullYear())));
    res.json({
      ok: true,
      msg: "Años obtenidos correctamente",
      data: anios
    });
  } catch (error) {
    console.log(error);
    res.status(500).json({
      ok: false,
      msg: "Por favor hable con el administrador",
    });
  }
};

const obtenerEmergencias = async (req, res) => {
  let emergencias = [];
  let consulta = {};
  try {
    const parametrosBusqueda = req.body;
    Object.keys(parametrosBusqueda).forEach(key => {
      if (parametrosBusqueda[key] !== '' && parametrosBusqueda[key] !== undefined) {
        consulta[key] = parametrosBusqueda[key];
      }
    });
    let publicaciones = await Publicacion.find(consulta);
    if (parametrosBusqueda.horaFin != undefined && parametrosBusqueda.horaFin.includes(':')) {
      const FechahoraFin = convertToEcuadorTimeZone(new Date(parametrosBusqueda.horaFin));
      const horaFin = FechahoraFin.getHours();
      const minutosFin = FechahoraFin.getMinutes();
      const documentosHoraFin = publicaciones.filter((publicacion) => {
        const hora = publicacion.createdAt.getHours();
        const minutos = publicacion.createdAt.getMinutes();

        return (hora < horaFin || (hora === horaFin && minutos <= minutosFin));
      });
      publicaciones = documentosHoraFin
    }

    if (parametrosBusqueda.horaInicio != undefined && parametrosBusqueda.horaInicio.includes(':')) {
      const FechahoraInicio = convertToEcuadorTimeZone(new Date(parametrosBusqueda.horaInicio));
      const horaInicio = FechahoraInicio.getHours();
      const minutosInicio = FechahoraInicio.getMinutes();
      const documentosHoraInicio = publicaciones.filter((publicacion) => {
        const hora = publicacion.createdAt.getHours();
        const minutos = publicacion.createdAt.getMinutes();
        return (hora > horaInicio || (hora === horaInicio && minutos >= minutosInicio));
      });
      publicaciones = documentosHoraInicio
    }


    emergencias = Array.from(new Set(publicaciones.map(publicacion => publicacion['titulo'])));
    res.json({
      ok: true,
      msg: "Emergencias obtenidas correctamente",
      data: emergencias
    });
  } catch (error) {
    console.log(error);
    res.status(500).json({
      ok: false,
      msg: "Por favor hable con el administrador",
    });
  }
};
const convertToEcuadorTimeZone = (date) => {
  const ecuadorTimeZoneOffset = -5 * 60; // -5 horas en minutos
  const userTimeZoneOffset = date.getTimezoneOffset(); // Obtener el offset del huso horario del usuario en minutos
  const gmtTime = date.getTime() + userTimeZoneOffset * 60 * 1000; // Convertir la hora a GMT
  const ecuadorTime = gmtTime + ecuadorTimeZoneOffset * 60 * 1000; // Agregar el offset de GMT-5
  return new Date(ecuadorTime);
};
const obtenerReporteBarras = async (req, res) => {
  let emergencias = [];
  let consulta = {};
  try {
    const parametrosBusqueda = req.body;

    Object.keys(parametrosBusqueda).forEach(key => {
      if (parametrosBusqueda[key] !== '' && parametrosBusqueda[key] !== undefined) {
        consulta[key] = parametrosBusqueda[key];
      }
    });





    if (parametrosBusqueda.fechaFin) {
      const fechaFin = new Date(parametrosBusqueda.fechaFin);
      fechaFin.setHours(23, 59, 59); // Establecer la hora de finalización a las 23:59:59
      consulta.createdAt = consulta.createdAt || {};
      consulta.createdAt.$lte = fechaFin;
    }

    if (parametrosBusqueda.fechaInicio) {
      const fechaInicio = new Date(parametrosBusqueda.fechaInicio);
      consulta.createdAt = consulta.createdAt || {};
      consulta.createdAt.$gte = fechaInicio;
    }



    let publicaciones = await Publicacion.find(consulta);

    if (parametrosBusqueda.horaFin != undefined && parametrosBusqueda.horaFin.includes(':')) {
      const FechahoraFin = convertToEcuadorTimeZone(new Date(parametrosBusqueda.horaFin));
      const horaFin = FechahoraFin.getHours();
      const minutosFin = FechahoraFin.getMinutes();
      const documentosHoraFin = publicaciones.filter((publicacion) => {
        const hora = publicacion.createdAt.getHours();
        const minutos = publicacion.createdAt.getMinutes();

        return (hora < horaFin || (hora === horaFin && minutos <= minutosFin));
      });
      publicaciones = documentosHoraFin
    }

    if (parametrosBusqueda.horaInicio != undefined && parametrosBusqueda.horaInicio.includes(':')) {
      const FechahoraInicio = convertToEcuadorTimeZone(new Date(parametrosBusqueda.horaInicio));
      const horaInicio = FechahoraInicio.getHours();
      const minutosInicio = FechahoraInicio.getMinutes();
      const documentosHoraInicio = publicaciones.filter((publicacion) => {
        const hora = publicacion.createdAt.getHours();
        const minutos = publicacion.createdAt.getMinutes();
        return (hora > horaInicio || (hora === horaInicio && minutos >= minutosInicio));
      });
      publicaciones = documentosHoraInicio
    }

    const conteoPorDia = {};

    // Crear un rango de días dentro de la fecha de inicio y fin
    const fechaInicio = new Date(parametrosBusqueda.fechaInicio);
    const fechaFin = new Date(parametrosBusqueda.fechaFin);
    const diaActual = new Date(fechaInicio);

    while (diaActual <= fechaFin) {
      const dia = diaActual.toISOString().substr(0, 10);
      conteoPorDia[dia] = 0;
      diaActual.setDate(diaActual.getDate() + 1); // Avanzar al siguiente día
    }

    // Iterar a través de las publicaciones y actualizar el conteo por día
    publicaciones.forEach(publicacion => {
      const fecha = new Date(publicacion.createdAt);
      const dia = fecha.toISOString().substr(0, 10);

      if (conteoPorDia[dia] !== undefined) {
        conteoPorDia[dia]++;
      }
    });


    res.json({
      ok: true,
      msg: "Datos para barras obtenidas correctamente",
      data: conteoPorDia
    });
  } catch (error) {
    console.log(error);
    res.status(500).json({
      ok: false,
      msg: "Por favor hable con el administrador",
    });
  }
};
const obtenerReportePastel = async (req, res) => {
  const conteoEmergencias = {};
  let consulta = {};
  try {
    const parametrosBusqueda = req.body;
    Object.keys(parametrosBusqueda).forEach(key => {
      if (parametrosBusqueda[key] !== '' && parametrosBusqueda[key] !== undefined) {
        consulta[key] = parametrosBusqueda[key];
      }
    });






    if (parametrosBusqueda.fechaFin) {
      const fechaFin = new Date(parametrosBusqueda.fechaFin);
      fechaFin.setHours(23, 59, 59); // Establecer la hora de finalización a las 23:59:59
      consulta.createdAt = consulta.createdAt || {};
      consulta.createdAt.$lte = fechaFin;
    }

    if (parametrosBusqueda.fechaInicio) {
      const fechaInicio = new Date(parametrosBusqueda.fechaInicio);
      consulta.createdAt = consulta.createdAt || {};
      consulta.createdAt.$gte = fechaInicio;
    }


    let publicaciones = await Publicacion.find(consulta);
    if (parametrosBusqueda.horaFin != undefined && parametrosBusqueda.horaFin.includes(':')) {
      const FechahoraFin = convertToEcuadorTimeZone(new Date(parametrosBusqueda.horaFin));
      const horaFin = FechahoraFin.getHours();
      const minutosFin = FechahoraFin.getMinutes();
      const documentosHoraFin = publicaciones.filter((publicacion) => {
        const hora = publicacion.createdAt.getHours();
        const minutos = publicacion.createdAt.getMinutes();

        return (hora < horaFin || (hora === horaFin && minutos <= minutosFin));
      });
      publicaciones = documentosHoraFin
    }

    if (parametrosBusqueda.horaInicio != undefined && parametrosBusqueda.horaInicio.includes(':')) {
      const FechahoraInicio = convertToEcuadorTimeZone(new Date(parametrosBusqueda.horaInicio));
      const horaInicio = FechahoraInicio.getHours();
      const minutosInicio = FechahoraInicio.getMinutes();
      const documentosHoraInicio = publicaciones.filter((publicacion) => {
        const hora = publicacion.createdAt.getHours();
        const minutos = publicacion.createdAt.getMinutes();
        return (hora > horaInicio || (hora === horaInicio && minutos >= minutosInicio));
      });
      publicaciones = documentosHoraInicio
    }


    let emergencias = publicaciones.forEach(publicacion => {
      const {
        titulo
      } = publicacion;
      if (conteoEmergencias[titulo]) {
        conteoEmergencias[titulo]++;
      } else {
        conteoEmergencias[titulo] = 1;
      }
    });
    res.json({
      ok: true,
      msg: "Datos de pastel",
      data: conteoEmergencias
    });
  } catch (error) {
    console.log(error);
    res.status(500).json({
      ok: false,
      msg: "Por favor hable con el administrador",
    });
  }
};
const obtenerMapaCalor = async (req, res) => {
  let consulta = {};
  try {
    const parametrosBusqueda = req.body;
    Object.keys(parametrosBusqueda).forEach(key => {
      if (parametrosBusqueda[key] !== '' && parametrosBusqueda[key] !== undefined) {
        consulta[key] = parametrosBusqueda[key];
      }
    });

    if (parametrosBusqueda.fechaFin) {
      const fechaFin = new Date(parametrosBusqueda.fechaFin);
      fechaFin.setHours(23, 59, 59); // Establecer la hora de finalización a las 23:59:59
      consulta.createdAt = consulta.createdAt || {};
      consulta.createdAt.$lte = fechaFin;
    }

    if (parametrosBusqueda.fechaInicio) {
      const fechaInicio = new Date(parametrosBusqueda.fechaInicio);
      consulta.createdAt = consulta.createdAt || {};
      consulta.createdAt.$gte = fechaInicio;
    }


    let publicaciones = await Publicacion.find(consulta);
    if (parametrosBusqueda.horaFin != undefined && parametrosBusqueda.horaFin.includes(':')) {
      const FechahoraFin = convertToEcuadorTimeZone(new Date(parametrosBusqueda.horaFin));
      const horaFin = FechahoraFin.getHours();
      const minutosFin = FechahoraFin.getMinutes();
      const documentosHoraFin = publicaciones.filter((publicacion) => {
        const hora = publicacion.createdAt.getHours();
        const minutos = publicacion.createdAt.getMinutes();

        return (hora < horaFin || (hora === horaFin && minutos <= minutosFin));
      });
      publicaciones = documentosHoraFin
    }

    if (parametrosBusqueda.horaInicio != undefined && parametrosBusqueda.horaInicio.includes(':')) {
      const FechahoraInicio = convertToEcuadorTimeZone(new Date(parametrosBusqueda.horaInicio));
      const horaInicio = FechahoraInicio.getHours();
      const minutosInicio = FechahoraInicio.getMinutes();
      const documentosHoraInicio = publicaciones.filter((publicacion) => {
        const hora = publicacion.createdAt.getHours();
        const minutos = publicacion.createdAt.getMinutes();
        return (hora > horaInicio || (hora === horaInicio && minutos >= minutosInicio));
      });
      publicaciones = documentosHoraInicio
    }


    const diasSemana = ['Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado'];
    const heatmapData = Array.from({
      length: 7
    }, () => ({
      name: '',
      data: Array(24).fill(0)
    }));

    diasSemana.map((diaSemana, index) => {
      heatmapData[index].name = diasSemana[index];
    });

    publicaciones.forEach((publicacion) => {
      const fecha = new Date(publicacion.createdAt);
      const diaSemana = fecha.getDay();
      const hora = fecha.getHours();

      heatmapData[diaSemana].name = diasSemana[diaSemana];
      heatmapData[diaSemana].data[hora] += 1;
    });

    const tooltip = Array.from({
      length: 7
    }, (_, index) => ({
      name: diasSemana[index],
      data: Array(24).fill(null).map(() => ({}))
    }));

    publicaciones.forEach((publicacion) => {
      const fecha = new Date(publicacion.createdAt);
      const diaSemana = fecha.getDay();
      const hora = fecha.getHours();
      const tituloEmergencia = publicacion.titulo;

      tooltip[diaSemana].data[hora][tituloEmergencia] = (tooltip[diaSemana].data[hora][tituloEmergencia] || 0) + 1;
    });
    const tooltiptime = Array.from({
      length: 7
    }, (_, index) => ({
      name: diasSemana[index],
      data: Array(24).fill(null).map(() => ({
        fechaMinima: new Date(), // Inicializa con una fecha futura
        fechaMaxima: new Date(0), // Inicializa con una fecha pasada
      }))
    }));


    publicaciones.forEach((publicacion) => {
      const fecha = new Date(publicacion.createdAt);
      const diaSemana = fecha.getDay();
      const hora = fecha.getHours();
      const tituloEmergencia = publicacion.titulo;

      const horaData = tooltiptime[diaSemana].data[hora];
      horaData[tituloEmergencia] = (horaData[tituloEmergencia] || 0) + 1;

      if (fecha < horaData.fechaMinima) {
        horaData.fechaMinima = fecha;
      }
      if (fecha > horaData.fechaMaxima) {
        horaData.fechaMaxima = fecha;
      }
    });

    // Formatear las fechas en un formato legible
    tooltiptime.forEach((dia) => {
      dia.data.forEach((horaData) => {
        horaData.fechaMinima = horaData.fechaMinima.toLocaleString();
        horaData.fechaMaxima = horaData.fechaMaxima.toLocaleString();
      });
    });

    let maxCount = 0;

    heatmapData.forEach((data, index) => {
      const maxInDay = Math.max(...data.data);
      if (maxInDay > maxCount) {
        maxCount = maxInDay;
      }
    });
    const segmentSize = Math.ceil(maxCount / 3);
    const ranges = [{
      from: 1,
      to: segmentSize,
      name: 'Bajo',
      color: '#A1D7C9'
    },
    {
      from: segmentSize + 1,
      to: segmentSize * 2,
      name: 'Medio',
      color: '#efa94a'
    },
    {
      from: segmentSize * 2 + 1,
      to: maxCount,
      name: 'Alto',
      color: '#FF4560'
    },
    ];


    res.json({
      ok: true,
      msg: "Datos de mapa  de calor",
      data: {
        heatmapData,
        ranges,
        tooltip,
        tooltiptime,
        total: publicaciones.length
      }
    });
  } catch (error) {
    console.log(error);
    res.status(500).json({
      ok: false,
      msg: "Por favor hable con el administrador",
    });
  }
};
const obtenerCoordenadas = async (req, res) => {
  let consulta = {};
  try {
    const parametrosBusqueda = req.body;
    Object.keys(parametrosBusqueda).forEach(key => {
      if (parametrosBusqueda[key] !== '' && parametrosBusqueda[key] !== undefined) {
        consulta[key] = parametrosBusqueda[key];
      }
    });






    if (parametrosBusqueda.fechaFin) {
      const fechaFin = new Date(parametrosBusqueda.fechaFin);
      fechaFin.setHours(23, 59, 59); // Establecer la hora de finalización a las 23:59:59
      consulta.createdAt = consulta.createdAt || {};
      consulta.createdAt.$lte = fechaFin;
    }

    if (parametrosBusqueda.fechaInicio) {
      const fechaInicio = new Date(parametrosBusqueda.fechaInicio);
      consulta.createdAt = consulta.createdAt || {};
      consulta.createdAt.$gte = fechaInicio;
    }


    let publicaciones = await Publicacion.find(consulta);
    if (parametrosBusqueda.horaFin != undefined && parametrosBusqueda.horaFin.includes(':')) {
      const FechahoraFin = convertToEcuadorTimeZone(new Date(parametrosBusqueda.horaFin));
      const horaFin = FechahoraFin.getHours();
      const minutosFin = FechahoraFin.getMinutes();
      const documentosHoraFin = publicaciones.filter((publicacion) => {
        const hora = publicacion.createdAt.getHours();
        const minutos = publicacion.createdAt.getMinutes();

        return (hora < horaFin || (hora === horaFin && minutos <= minutosFin));
      });
      publicaciones = documentosHoraFin
    }

    if (parametrosBusqueda.horaInicio != undefined && parametrosBusqueda.horaInicio.includes(':')) {
      const FechahoraInicio = convertToEcuadorTimeZone(new Date(parametrosBusqueda.horaInicio));
      const horaInicio = FechahoraInicio.getHours();
      const minutosInicio = FechahoraInicio.getMinutes();
      const documentosHoraInicio = publicaciones.filter((publicacion) => {
        const hora = publicacion.createdAt.getHours();
        const minutos = publicacion.createdAt.getMinutes();
        return (hora > horaInicio || (hora === horaInicio && minutos >= minutosInicio));
      });
      publicaciones = documentosHoraInicio
    }



    const coordenadas = publicaciones.map(publicacion => {
      return {
        titulo: publicacion.titulo,
        position: [publicacion.latitud, publicacion.longitud]
      }
    });



    res.json({
      ok: true,
      msg: "Datos de mapa  de calor",
      data: coordenadas
    });
  } catch (error) {
    console.log(error);
    res.status(500).json({
      ok: false,
      msg: "Por favor hable con el administrador",
    });
  }
};

const descargarXLSX = async (req, res) => {
  let consulta = {};
  try {
    const parametrosBusqueda = req.body;
    Object.keys(parametrosBusqueda).forEach((key) => {
      if (
        parametrosBusqueda[key] !== "" &&
        parametrosBusqueda[key] !== undefined
      ) {
        consulta[key] = parametrosBusqueda[key];
      }
    });

    if (parametrosBusqueda.fechaFin) {
      const fechaFin = new Date(parametrosBusqueda.fechaFin);
      fechaFin.setHours(23, 59, 59); // Establecer la hora de finalización a las 23:59:59
      consulta.createdAt = consulta.createdAt || {};
      consulta.createdAt.$lte = fechaFin;
    }

    if (parametrosBusqueda.fechaInicio) {
      const fechaInicio = new Date(parametrosBusqueda.fechaInicio);
      consulta.createdAt = consulta.createdAt || {};
      consulta.createdAt.$gte = fechaInicio;
    }

    //cambiar la propiedad de createdAt por FechaInicio
    let publicaciones = await Publicacion.find(consulta, { nombreUsuario: 0 });
    if (
      parametrosBusqueda.horaFin != undefined &&
      parametrosBusqueda.horaFin.includes(":")
    ) {
      const FechahoraFin = convertToEcuadorTimeZone(
        new Date(parametrosBusqueda.horaFin)
      );
      const horaFin = FechahoraFin.getHours();
      const minutosFin = FechahoraFin.getMinutes();
      const documentosHoraFin = publicaciones.filter((publicacion) => {
        const hora = publicacion.FechaInicio.getHours();
        const minutos = publicacion.FechaInicio.getMinutes();

        return hora < horaFin || (hora === horaFin && minutos <= minutosFin);
      });
      publicaciones = documentosHoraFin;
    }

    if (
      parametrosBusqueda.horaInicio != undefined &&
      parametrosBusqueda.horaInicio.includes(":")
    ) {
      const FechahoraInicio = convertToEcuadorTimeZone(
        new Date(parametrosBusqueda.horaInicio)
      );
      const horaInicio = FechahoraInicio.getHours();
      const minutosInicio = FechahoraInicio.getMinutes();
      const documentosHoraInicio = publicaciones.filter((publicacion) => {
        const hora = publicacion.FechaInicio.getHours();
        const minutos = publicacion.FechaInicio.getMinutes();
        return (
          hora > horaInicio || (hora === horaInicio && minutos >= minutosInicio)
        );
      });
      publicaciones = documentosHoraInicio;
    }


    //eliminar de publicaciones nombreUsuario

    //eliminar nombreUsuario de todos las publicaciones


    exportToExcel(publicaciones)
      .then((buffer) => {
        // Configurar las cabeceras para la descarga del archivo
        res.setHeader("Content-Disposition", "attachment; filename=Reporte_IncidentesUE.xlsx");
        res.setHeader(
          "Content-Type",
          "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        );

        // Enviar el archivo de Excel como respuesta
        res.send(buffer);
      })
      .catch((error) => {
        console.error("Error al generar el archivo de Excel:", error);
        res.status(500).send("Error al generar el archivo de Excel.");
      });
  } catch (error) {
    console.log(error);
    res.status(500).json({
      ok: false,
      msg: "Por favor hable con el administrador",
    });
  }
};


const descargarCSV = async (req, res) => {
  let consulta = {};
  try {
    const parametrosBusqueda = req.body;
    Object.keys(parametrosBusqueda).forEach(key => {
      if (parametrosBusqueda[key] !== '' && parametrosBusqueda[key] !== undefined) {
        consulta[key] = parametrosBusqueda[key];
      }
    });



    if (parametrosBusqueda.fechaFin) {
      const fechaFin = new Date(parametrosBusqueda.fechaFin);
      fechaFin.setHours(23, 59, 59); // Establecer la hora de finalización a las 23:59:59
      consulta.createdAt = consulta.createdAt || {};
      consulta.createdAt.$lte = fechaFin;
    }

    if (parametrosBusqueda.fechaInicio) {
      const fechaInicio = new Date(parametrosBusqueda.fechaInicio);
      consulta.createdAt = consulta.createdAt || {};
      consulta.createdAt.$gte = fechaInicio;
    }


    let publicaciones = await Publicacion.find(consulta, { nombreUsuario: 0 });
    if (parametrosBusqueda.horaFin != undefined && parametrosBusqueda.horaFin.includes(':')) {
      const FechahoraFin = convertToEcuadorTimeZone(new Date(parametrosBusqueda.horaFin));
      const horaFin = FechahoraFin.getHours();
      const minutosFin = FechahoraFin.getMinutes();
      const documentosHoraFin = publicaciones.filter((publicacion) => {
        const hora = publicacion.createdAt.getHours();
        const minutos = publicacion.createdAt.getMinutes();

        return (hora < horaFin || (hora === horaFin && minutos <= minutosFin));
      });
      publicaciones = documentosHoraFin
    }

    if (parametrosBusqueda.horaInicio != undefined && parametrosBusqueda.horaInicio.includes(':')) {
      const FechahoraInicio = convertToEcuadorTimeZone(new Date(parametrosBusqueda.horaInicio));
      const horaInicio = FechahoraInicio.getHours();
      const minutosInicio = FechahoraInicio.getMinutes();
      const documentosHoraInicio = publicaciones.filter((publicacion) => {
        const hora = publicacion.createdAt.getHours();
        const minutos = publicacion.createdAt.getMinutes();
        return (hora > horaInicio || (hora === horaInicio && minutos >= minutosInicio));
      });
      publicaciones = documentosHoraInicio
    }


    exportToCSV(publicaciones)
      .then((buffer) => {
        //  Configurar las cabeceras para la descarga del archivo
        res.setHeader('Content-Disposition', 'attachment; filename=ReporteIncidentesUE.xlsx');
        res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');

        // Enviar el archivo de Excel como respuesta
        res.send(buffer);
      })
      .catch((error) => {
        console.error('Error al generar el archivo de Excel:', error);
        res.status(500).send('Error al generar el archivo de Excel.');
      });

  } catch (error) {
    console.log(error);
    res.status(500).json({
      ok: false,
      msg: "Por favor hable con el administrador",
    });
  }
};


process.env.OPENSSL_CONF = '/dev/null';

const descargarPDF = async (req, res) => {
  let consulta = {};
  try {
    const parametrosBusqueda = req.body;

    Object.keys(parametrosBusqueda).forEach((key) => {
      if (
        parametrosBusqueda[key] !== "" &&
        parametrosBusqueda[key] !== undefined
      ) {
        consulta[key] = parametrosBusqueda[key];
      }
    });

    if (parametrosBusqueda.fechaFin) {
      const fechaFin = new Date(parametrosBusqueda.fechaFin);
      fechaFin.setHours(23, 59, 59); // Establecer la hora de finalización a las 23:59:59
      consulta.createdAt = consulta.createdAt || {};
      consulta.createdAt.$lte = fechaFin;
    }

    if (parametrosBusqueda.fechaInicio) {
      const fechaInicio = new Date(parametrosBusqueda.fechaInicio);
      consulta.createdAt = consulta.createdAt || {};
      consulta.createdAt.$gte = fechaInicio;
    }

    let publicaciones = await Publicacion.find(consulta);
    if (
      parametrosBusqueda.horaFin != undefined &&
      parametrosBusqueda.horaFin.includes(":")
    ) {
      const FechahoraFin = convertToEcuadorTimeZone(
        new Date(parametrosBusqueda.horaFin)
      );
      const horaFin = FechahoraFin.getHours();
      const minutosFin = FechahoraFin.getMinutes();
      const documentosHoraFin = publicaciones.filter((publicacion) => {
        const hora = publicacion.createdAt.getHours();
        const minutos = publicacion.createdAt.getMinutes();

        return hora < horaFin || (hora === horaFin && minutos <= minutosFin);
      });
      publicaciones = documentosHoraFin;
    }

    if (
      parametrosBusqueda.horaInicio != undefined &&
      parametrosBusqueda.horaInicio.includes(":")
    ) {
      const FechahoraInicio = convertToEcuadorTimeZone(
        new Date(parametrosBusqueda.horaInicio)
      );
      const horaInicio = FechahoraInicio.getHours();
      const minutosInicio = FechahoraInicio.getMinutes();
      const documentosHoraInicio = publicaciones.filter((publicacion) => {
        const hora = publicacion.createdAt.getHours();
        const minutos = publicacion.createdAt.getMinutes();
        return (
          hora > horaInicio || (hora === horaInicio && minutos >= minutosInicio)
        );
      });
      publicaciones = documentosHoraInicio;
    }

    console.log(publicaciones);



    //TODO: total usuarios
    const totalUsuarios = await Usuario.countDocuments();
    console.log(totalUsuarios);//46

    //TODO: total publicaciones por dia, dia acutal
    const fechaActual = new Date();

    const fechaInicio = new Date(fechaActual.getFullYear(), fechaActual.getMonth(), fechaActual.getDate(), 0, 0, 0);
    const fechaFin = new Date(fechaActual.getFullYear(), fechaActual.getMonth(), fechaActual.getDate(), 23, 59, 59);

    const totalPublicacionesDia = await Publicacion.countDocuments({
      createdAt: {
        $gte: fechaInicio,
        $lte: fechaFin
      }
    });
    console.log(totalPublicacionesDia);//29

    //TODO: total publicaciones por MES, mes actual
    const fechaInicioMes = new Date(fechaActual.getFullYear(), fechaActual.getMonth(), 1, 0, 0, 0);
    const fechaFinMes = new Date(fechaActual.getFullYear(), fechaActual.getMonth() + 1, 0, 23, 59, 59);

    const totalPublicacionesMes = await Publicacion.countDocuments({
      createdAt: {
        $gte: fechaInicioMes,
        $lte: fechaFinMes
      }
    });
    console.log(publicaciones);//29


    //taotal ublicaciones registradas en el sistema
    const totalPublicacionesCoutn = await Publicacion.countDocuments();


    //objeto de persona con nombre y edad
    const dataInfo = {
      totalUsuarios: totalUsuarios,
      totalPublicacionesDia: totalPublicacionesDia,
      totalPublicacionesMes: totalPublicacionesMes,
      publicaciones: publicaciones,
      totalPublicacionesCoutn: totalPublicacionesCoutn
    }



    const pdfOptions = {
      childProcessOptions: {
        env: {
          OPENSSL_CONF: '/dev/null', // Configuración para evitar problemas SSL
        },
      },
    };


    const pdfFilePath = path.join(__dirname, '../../uploads/Reporte_IncidentesUE.pdf'); // Ruta donde deseas guardar el PDF

    pdf.create(pdfTemplate(dataInfo), pdfOptions).toFile(pdfFilePath, (err) => {
      if (err) {
        console.log('Error creating PDF:', err);
        // Maneja el error de acuerdo a tus necesidades
        // res.send(Promise.reject());
      } else {
        console.log('PDF has been successfully created and saved.');
        // Realiza acciones adicionales si es necesario
        // res.send(Promise.resolve());
      }
    });


    // Configurar los encabezados de la respuesta para descargar el archivo PDF
    const filename = "Reporte_IncidentesUE.pdf";
    res.setHeader("Content-Disposition", `attachment; filename="${filename}"`);
    res.setHeader("Content-Type", "application/pdf");

    // Obtener la ruta absoluta de las fuentes Roboto
    const fonts = {
      Roboto: {
        normal: require.resolve(
          "pdfmake-unicode/src/fonts/Arial GEO/Roboto-Regular.ttf"
        ),
        bold: require.resolve(
          "pdfmake-unicode/src/fonts/Arial GEO/Roboto-Medium.ttf"
        ),
      },
    };

    // Crear un objeto de definición de PDF utilizando pdfmake
    const printer = new pdfMakePrinter(fonts);
    const docDefinition = {
      content: [
        { text: "Lista de Publicaciones", style: "header" },
        {
          table: {
            headerRows: 1,
            widths: ["auto", "auto", "auto", "auto", "auto", "auto", "auto"],
            body: [
              [
                { text: "Título", style: "header2" },
                { text: "Contenido", style: "header2" },
                { text: "Ciudad", style: "header2" },
                { text: "Barrio", style: "header2" },
                { text: "Nombre de Usuario", style: "header2" },
                { text: "Latitud", style: "header2" },
                { text: "Longitud", style: "header2" },
              ],
              ...publicaciones.map((publicacion) => [
                publicacion.titulo,
                publicacion.contenido,
                publicacion.ciudad,
                publicacion.barrio,
                publicacion.nombreUsuario,
                publicacion.latitud.toString(),
                publicacion.longitud.toString(),
              ]),
            ],
          },
        },
      ],
      styles: {
        header: {
          fontSize: 18,
          bold: true,
          alignment: "center",
        },
        header2: {
          fontSize: 12,
          bold: true,
          alignment: "center",
        },
      },
    };
    const pdfDoc = printer.createPdfKitDocument(docDefinition);
    pdfDoc.pipe(res);
    pdfDoc.end();
  } catch (error) {
    console.log(error);
    res.status(500).json({
      ok: false,
      msg: "Por favor hable con el administrador",
    });
  }
};


// Función para exportar un array de objetos a Excel
async function exportToExcel(dataArray) {
  const workbook = new ExcelJS.Workbook();
  const worksheet = workbook.addWorksheet("Reporte_IncidentesUE");

  // Definir los encabezados de las columnas en la hoja de cálculo
  console.log(dataArray);
  let objeto = dataArray[0]._doc;
  delete objeto._id;
  delete objeto.color;
  delete objeto.isPublic;
  delete objeto.usuario;
  delete objeto.likes;
  delete objeto.imagenes;
  delete objeto.comentarios;
  delete objeto.__v;
  delete objeto.isActivo;
  delete objeto.isLiked;
  delete objeto.imgAlerta;
  delete objeto.isPublicacionPendiente;
  delete objeto.updatedAt;
  delete objeto.fechaPublicacion;

  // Cambiar encabezado de createdAt por FechaCreacion
  objeto.FechaCreacion = objeto.createdAt;
  delete objeto.createdAt;

  // Cambiar los encabezados de las columnas a español y mayúsculas
  const headerTranslations = {
    titulo: "Tipo emergencia comunitaria",
    contenido: "Descripción de la emergencia",
    color: "Color",
    ciudad: "Ciudad",
    barrio: "Barrio",
    isPublic: "Es Público",
    usuario: "Usuario",
    nombreUsuario: "Nombre de Usuario",
    likes: "Likes",
    imagenes: "Imágenes",
    latitud: "Latitud",
    longitud: "Longitud",
    comentarios: "Comentarios",
    imgAlerta: "Imagen de Alerta",
    isLiked: "Es Favorito",
    isActivo: "Es Activo",
    FechaCreacion: "Fecha de publicación",
    isPublicacionPendiente: "Publicación Pendiente",
  };

  const columnHeaders = Object.keys(objeto).map(header => {
    if (headerTranslations.hasOwnProperty(header)) {
      return headerTranslations[header];
    } else {
      return header.charAt(0).toUpperCase() + header.slice(1);
    }
  });

  console.log(columnHeaders);
  worksheet.addRow(columnHeaders);

  // Llenar la hoja de cálculo con los datos de los objetos
  dataArray.forEach((dataObj) => {
    let objeto = Object.values(dataObj)[2];
    delete objeto._id;
    delete objeto.color;
    delete objeto.isPublic;
    delete objeto.usuario;
    delete objeto.likes;
    delete objeto.imagenes;
    delete objeto.comentarios;
    delete objeto.__v;
    delete objeto.isActivo;
    delete objeto.isLiked;
    delete objeto.imgAlerta;
    delete objeto.isPublicacionPendiente;
    delete objeto.fechaPublicacion;
    delete objeto.updatedAt;

    worksheet.addRow(Object.values(objeto));
  });

  worksheet.columns.forEach((column, index) => {
    let maxLength = 0;
    worksheet.eachRow((row, rowNumber) => {
      if (rowNumber > 1) {
        const cellValue = row.getCell(index + 1).value;
        if (cellValue && cellValue.toString().length > maxLength) {
          maxLength = cellValue.toString().length;
        }
      }
    });
    // Limitar el ancho de las celdas al máximo permitido (16384)
    column.width = Math.min(maxLength < 12 ? 12 : maxLength, 16384);
  });

  // Devolver el archivo de Excel como un buffer
  const buffer = await workbook.xlsx.writeBuffer();
  return buffer;
}




// Función para exportar un array de objetos a Excel
async function exportToCSV(dataArray) {
  const workbook = new ExcelJS.Workbook();
  const worksheet = workbook.addWorksheet('Reporte_IncidentesUE');

  // Definir los encabezados de las columnas en la hoja de cálculo
  let objeto = dataArray[0]._doc;

  // Agrega aquí los campos que deseas eliminar
  const camposEliminar = ['_id', 'color', 'isPublic', 'usuario', 'likes', 'imagenes', 'comentarios', '__v', 'isActivo', 'isLiked', 'imgAlerta', 'isPublicacionPendiente', 'fechaPublicacion', 'updatedAt'];

  camposEliminar.forEach(campos => {
    delete objeto[campos];
  });

  // Cambiar encabezado de createdAt por FechaCreacion
  objeto.FechaCreacion = objeto.createdAt;
  delete objeto.createdAt;

  // Cambiar los encabezados de las columnas a español y mayúsculas
  const headerTranslations = {
    titulo: "Tipo emergencia comunitaria",
    contenido: "Descripción de la emergencia",
    color: "Color",
    ciudad: "Ciudad",
    barrio: "Barrio",
    isPublic: "Es Público",
    usuario: "Usuario",
    nombreUsuario: "Nombre de Usuario",
    likes: "Likes",
    imagenes: "Imágenes",
    latitud: "Latitud",
    longitud: "Longitud",
    comentarios: "Comentarios",
    imgAlerta: "Imagen de Alerta",
    isLiked: "Es Favorito",
    isActivo: "Es Activo",
    FechaCreacion: "Fecha de publicación",
    isPublicacionPendiente: "Publicación Pendiente",
  };

  const columnHeaders = Object.keys(objeto).map(header => {
    if (headerTranslations.hasOwnProperty(header)) {
      return headerTranslations[header];
    } else {
      return header.charAt(0).toUpperCase() + header.slice(1);
    }
  });

  worksheet.addRow(columnHeaders);

  // Llenar la hoja de cálculo con los datos de los objetos
  dataArray.forEach((dataObj) => {
    let objeto = Object.values(dataObj)[2];

    camposEliminar.forEach(campos => {
      delete objeto[campos];
    });

    worksheet.addRow(Object.values(objeto));
  });

  worksheet.columns.forEach((column, index) => {
    let maxLength = 0;
    worksheet.eachRow((row, rowNumber) => {
      if (rowNumber > 1) {
        const cellValue = row.getCell(index + 1).value;
        if (cellValue && cellValue.toString().length > maxLength) {
          maxLength = cellValue.toString().length;
        }
      }
    });
    // Limitar el ancho de las celdas al máximo permitido (16384)
    column.width = Math.min(maxLength < 12 ? 12 : maxLength, 16384);
  });

  // Devolver el archivo de Excel como un buffer
  const buffer = await workbook.xlsx.writeBuffer();
  return buffer;
}





module.exports = {
  obtenerCiudades,
  obtenerBarrios,
  obtenerEmergencias,
  obtenerAnios,
  obtenerReporteBarras,
  obtenerReportePastel,
  obtenerMapaCalor,
  obtenerDatosCards,
  obtenerCoordenadas,
  descargarXLSX,
  descargarPDF,
  descargarCSV,
  obtenerUnidadesEducativas
};