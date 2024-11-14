const admin = require('firebase-admin');
require('dotenv').config(); 

const serviceAccount = require('./upgraded-eureka-bc23a-firebase-adminsdk-nlref-242bab2c07.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  storageBucket: process.env.STORAGE_BUCKET,
});

module.exports = admin;