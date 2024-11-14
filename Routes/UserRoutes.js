const router = require("express").Router();
const admin = require('../firebase_admin');
const firestore = admin.firestore();

router.route('/create/:id').post( async (req, res) => {

    const id = req.params.id;
    const { displayName, email, profileImg } = req.body;

    firestore.collection("users").doc(id).set({
        displayName: displayName,
        email: email,
        profileImg: profileImg,
    })
    .then(() => {
        res.status(200).json({ message: "Doc created!" });
    })
    .catch((error) => {
        res.status(400).json({ code: error.code, error: error.message });
    });
  
});

router.route('/update/:id').post( async (req, res) => {
    const id = req.params.id;
    const { displayName, email, profileImg } = req.body;

    firestore.collection("users").doc(id).set({
        displayName: displayName,
        email: email,
        profileImg: profileImg,
    })
    .then(() => {
        res.status(200).json({ message: "Doc updated!" });
    })
    .catch((error) => {
        res.status(400).json({ code: error.code, error: error.message });
    });

});

router.route('/read_all').post( async (req, res) => {

    firestore.collection("users").get().then((querySnapshot) => {
        querySnapshot.forEach((doc) => {
            var docs = [];
            docs.push(doc.data());
            res.status(200).json({docs});
        });
    });
    
});

router.route('/read_one/:id').post( async (req, res) => {
    
    const id = req.params.id;
    var docRef = firestore.collection("users").doc(id);

docRef.get().then((doc) => {
    if (doc.exists) {
        res.status(200).json(doc.data());
    } else {
        res.status(400).json({ message: "Doc not found!" });
    }
}).catch((error) => {
    res.status(400).json({ code: error.code, error: error.message });
});
});

router.route('/delete/:id').post( async (req, res) => {
    
    const id = req.params.id;

    firestore.collection("users").doc(id).delete().then(() => {
        res.status(200).json({ message: "Document deleted." });
    }).catch((error) => {
        res.status(400).json({ code: error.code, error: error.message });
    });
});

module.exports = router;