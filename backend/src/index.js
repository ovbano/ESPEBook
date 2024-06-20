const app = require('./app');
const { dbConection } = require('./databaseMongo');

async function main() {
  //Primero nos conectamos a la base de datos
  await dbConection();
  //Despues inicio mi servidor 
  await app.listen(4444);
}

// app.listen(4444, () => {
//   console.log('Server started on port ' + 4444);
// });

main();