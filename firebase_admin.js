const admin = require('firebase-admin');

const serviceAccount = require('./upgraded-eureka-bc23a-firebase-adminsdk-nlref-242bab2c07.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const firestore = admin.firestore();
module.exports = firestore;