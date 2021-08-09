const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp(functions.config().firebase);

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const get_my_feedbacks = require('./get_my_feedbacks');
exports.get_my_feedbacks = get_my_feedbacks.get_my_feedbacks;

const calculate_SOZIP_Participants = require('./calculate_SOZIP_Participants');
exports.calculate_SOZIP_Participants = calculate_SOZIP_Participants.calculate_SOZIP_Participants;

const cancel_SOZIP = require('./cancel_SOZIP');
exports.cancel_SOZIP = cancel_SOZIP.cancel_SOZIP;

const chatManagement = require('./chatManagement');
exports.chatManagement = chatManagement.chatManagement;