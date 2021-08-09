const functions = require("firebase-functions");
const admin = require("firebase-admin");

exports.do_secession = functions.firestore.document("Users/{docId}")
    .onDelete((snap, context) => {
        const deletedValue = snap.data();

        
    })