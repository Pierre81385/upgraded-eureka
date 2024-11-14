const router = require("express").Router();
const admin = require('../firebase_admin');
const auth = admin.auth();


router.route('/create').post(async (req, res) => {
  const { email, password, displayName, photoURL } = req.body;

  try {
    const userRecord = await auth.createUser({
      email,
      password,
      displayName, 
      photoURL,    
    });

    res.status(200).json({
      uid: userRecord.uid,
      displayName: userRecord.displayName,
      photoURL: userRecord.photoURL,
    });
  } catch (error) {
    res.status(400).json({ code: error.code, error: error.message });
  }
});

router.route('/login').post( async (req, res) => {

    const { email, password } = req.body;

    auth.signInWithEmailAndPassword(email, password)
  .then((userCredential) => {
    var user = userCredential.user;
    res.status(200).json({ uid: user.uid });
  })
  .catch((error) => {
    res.status(400).json({ code: error.code, error: error.message });
  });
  
});

router.route('/current-user').get((req,res) => {
  const user = auth.currentUser;
  if (user) {
    res.status(200).json(user);
  } else {
    res.status(400);
  }
})

router.route('/logout').post( async (req, res) => {

  const { uid } = req.body;

  auth.signOut().then(() => {
    res.status(200).json({ user: uid });
  }).catch((error) => {
    res.status(400).json({ code: error.code, error: error.message });
  });
});


module.exports = router;