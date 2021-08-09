const functions = require("firebase-functions");
const admin = require("firebase-admin");

exports.calculate_SOZIP_Participants = functions.firestore
    .document('SOZIP/{docId}')
    .onUpdate((change, context) => {
        const data = change.after.data();
        const oldData = change.before.data();

        const new_participate = data.participants;
        const old_participate = oldData.participants;

        const newParticipateArray = Object.keys(new_participate);
        const oldParticipateArray = Object.keys(old_participate);
            
        if (newParticipateArray.length > oldParticipateArray.length){
            const manager = data.Manager;

            const ref = admin.firestore().collection("SOZIP").doc(context.params.docId)

            ref.update({currentPeople : newParticipateArray.length})

            return admin.firestore().collection("Users").doc(manager).get().then((value) => {
                const targetToken = value.data().token;
                const payload = {
                    notification : {
                        title : "새로운 멤버가 소집에 참여했어요!",
                        body : "지금 확인해보세요!"
                    },
                };

                return Promise.all([targetToken, data]).then(result => {
                    admin.messaging().sendToDevice(targetToken, payload).then((response) => {
                        response.results.forEach((result, index) => {
                            const error = result.error
    
                            if(error){
                                console.error("FCM Failed : ", error.code);
                            }
    
                            else{
    
                            }
                        })
                    })
                })

                
            })

            return console.log("new participants.");
        }

        else if (newParticipateArray.length < oldParticipateArray.length){
            const manager = data.Manager;

            const ref = admin.firestore().collection("SOZIP").doc(context.params.docId)

            ref.update({currentPeople : newParticipateArray.length})

            return admin.firestore().collection("Users").doc(manager).get().then((value) => {
                const targetToken = value.data().token;
                const payload = {
                    notification : {
                        title : "소집 멤버가 소집을 떠났어요 :(",
                        body : "지금 앱에서 확인해보세요!"
                    },
                };

                return Promise.all([targetToken, data]).then(result => {
                    admin.messaging().sendToDevice(targetToken, payload).then((response) => {
                        response.results.forEach((result, index) => {
                            const error = result.error
    
                            if(error){
                                console.error("FCM Failed : ", error.code);
                            }
    
                            else{
    
                            }
                        })
                    })
                })
            })
        }
    })