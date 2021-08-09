const functions = require("firebase-functions");
const admin = require("firebase-admin");

exports.chatManagement = functions.firestore
    .document("SOZIP/{docId}/Chat/{chatId}")
    .onCreate((snap, context) => {
        const newValue = snap.data();
        const msg = newValue.msg;
        const time = newValue.date;
        const type = newValue.msg_type;
        const parentPath = context.params.docId;
        const sender = newValue.sender;

        return admin.firestore().collection("SOZIP").doc(parentPath).get().then((value) => {
            const ref = admin.firestore().collection("SOZIP").doc(parentPath)

            ref.update({
                last_msg : msg,
                last_msg_time : time,
                last_msg_type : type
            })

            const participants = value.data().participants;
            const participantArray = Object.keys(participants);
            var targetToken = "";

            const payload = {
                notification : {
                    title : "새로운 채팅이 있어요!",
                    body : "참여 중인 소집에 새로운 채팅이 도착했어요!"
                },
            };

            for(let i in participantArray){
                if (participantArray[i] != sender){
                    return admin.firestore().collection("Users").doc(participantArray[i]).get().then((userVal) => {
                        targetToken = userVal.data().token;

                        return Promise.all([targetToken, newValue]).then(result => {
                            admin.messaging().sendToDevice(targetToken, payload).then((response) => {
                                response.results.forEach((result, index) => {
                                    const error = result.error
    
                                    if (error){
                                        console.error("FCM Failed : ", error.code);
                                    }
                                })
                            })
                        })
                    })
                }
            }
        })
    })