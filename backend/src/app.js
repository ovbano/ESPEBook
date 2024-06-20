const express =  require('express');
const bodyParser = require('body-parser');
const fileUpload = require('express-fileupload');
const path = require("path");

const app = express();

const server = require("http").createServer(app);
module.exports.io = require("socket.io")(server);

const publicPath = path.resolve(__dirname, "./prueba/public");

app.use(express.static(publicPath));


app.use(
    fileUpload({
      useTempFiles: true,
      tempFileDir: "/tmp/",
      createParentPath: true
    })
);

const morgan = require('morgan');
const cors = require('cors');


// app.use(express.urlencoded({extended: true})); 
app.use(bodyParser.urlencoded({ limit: '15MB',extended: true, parameterLimit:50000 }));
app.use(bodyParser.json({ limit: '15MB'}));
app.set('port', 4444 || 4444);
app.use(express.json());

app.use(morgan('dev'));
app.use(cors());


const AUTH = require("./routes/auth");
const MENSAJES = require("./routes/mensajes");
const  USUARIOS = require("./routes/usuario");
const SALAS = require("./routes/salas");
const PBLIC = require("./routes/publicaciones");
const  COM = require("./routes/comentario");
const UPLS = require("./routes/uploads");
const BUSCAR = require("./routes/buscar");
const UBICAIONALL = require("./routes/ubicaciones");
const REPORTM = require("./routes/reportes");
const NOTIFICACION = require("./routes/notificaciones");
const DENUNCIAS = require("./routes/denuncias");
const EMAILESPES  = require("./routes/email");
const DOCUMENTOS  = require("./routes/documents");

app.use("/api/comentario", COM);
app.use("/api/login", AUTH);
app.use("/api/mensajes", MENSAJES);
app.use("/api/publicacion", PBLIC);
app.use("/api/salas", SALAS);
app.use("/api/uploads", UPLS);
app.use("/api/usuario", USUARIOS);
app.use("/api/buscar", BUSCAR);
app.use("/api/ubicaciones", UBICAIONALL);
app.use("/api/reportes", REPORTM);
app.use("/api/notificacion", NOTIFICACION);
app.use("/api/denuncias", DENUNCIAS);
app.use("/api/email", EMAILESPES);
app.use("/api/documents", DOCUMENTOS);

//app.use(require('./routes/usuario'));
// app.use(require('./routes/auth'));
// app.use(require('./routes/comentario'));
// app.use(require('./routes/notificaciones'));
// app.use(require('./routes/publicaciones'));
// app.use(require('./routes/mensajes'));
// app.use(require('./routes/salas'));
// app.use(require('./routes/publicaciones'));
// app.use(require('./routes/buscar'));
// app.use(require('./routes/ubicaciones'));
// app.use(require('./routes/denuncias'));
// app.use(require('./routes/email'));
// app.use(require('./routes/documents'));
// app.use(require('./routes/uploads'));





module.exports = app, server;