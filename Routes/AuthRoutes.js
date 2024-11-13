const router = require("express").Router();
const firebase = require('../firebase.js')

router.route('/create').post( async (req, res) => {

    const { email, password } = req.body;

    const user = await firebase.auth().createUserWithEmailAndPassword(email, password)
    .then(() => {
      res.status(200).json({ uid: user.uid });
    })
    .catch((error) => {
      res.status(400).json({ code: error.code, error: error.message });
    });;
  
});

router.route('/login').post( async (req, res) => {

    const { email, password } = req.body;

    firebase.auth().signInWithEmailAndPassword(email, password)
  .then((userCredential) => {
    var user = userCredential.user;
    res.status(201).json({ uid: user.uid });
  })
  .catch((error) => {
    res.status(400).json({ code: error.code, error: error.message });
  });
  
});

router.route('/current_user').get((req,res) => {
  const user = firebase.auth().currentUser;
  if (user) {
    res.status(200).json(user);
  } else {
    res.status(400);
  }
})

router.route('/logout').post( async (req, res) => {

  const { uid } = req.body;

  firebase.auth().signOut().then(() => {
    res.status(200).json({ user: uid });
  }).catch((error) => {
    res.status(400).json({ code: error.code, error: error.message });
  });
});


module.exports = router;