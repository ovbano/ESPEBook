const mongose = require('mongoose');
const dbConection = async() => {
    try {
        console.log('Conectando DB..............................................');
        await mongose.connect('mongodb://10.141.0.170:27018/ESPEBook', {});
        console.log('CONECTADO...................................................');

    } catch (error) {

        throw new Error(error);

    }
}

module.exports = {
    dbConection
};