module.exports = {
  apps : [{
    script: 'src/index.js',
    interpreter: 'babel-node',
    watch:["src"],
    ignore_watch: ["uploads"],// Ignorar archivos dentro de la carpeta
  }
]
};
