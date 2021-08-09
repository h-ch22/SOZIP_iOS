const functions = require("firebase-functions");
const admin = require("firebase-admin");

exports.cancel_SOZIP = functions.firestore
    .document("SOZIP/{docId}")
    .onUpdate((change, context) => {
        const data = change.after.data();
        const oldData = change.before.data();

        const new_status = data.status;
        const old_status = oldData.status;

        var targetToken = ""
        
        if (new_status != old_status){
            if(new_status == "closed"){
                const participants = data.participants;
                const participantArray = Object.keys(participants);

                var target = ""
                for(let i in participantArray){
                    target = participantArray[i]

                    return admin.firestore().collection("Users").doc(target).get().then((value) => {
                        targetToken = value.data().token;
                        
                        const payload = {
                            notification : {
                                title : "소집이 취소되었어요.",
                                body : "앱에서 다른 소집을 찾아보세요!\n돈을 돌려받지 못했나요? 신고 기능을 이용하세요!"
                            },
                        };
        
                        return Promise.all([targetToken, data]).then(result => {
                            admin.messaging().sendToDevice(targetToken, payload).then((response) => {
                                response.results.forEach((result, index) => {
                                    const error = result.error
        
                                    if(error){
                                        console.error("FCM Failed : ", error.code);
                                    }
                                })
                            })
                        })
                    })
                }
                

                
            }

            else if(new_status == "paused"){
                const Manager = data.Manager;

                return admin.firestore().collection("Users").doc(Manager).get().then((value) => {
                    targetToken = value.data().token;

                    const payload = {
                        notification : {
                            title : "소집이 일시정지 되었어요.",
                            body : "일시정지 되어있는 동안은 소집 목록에\n소집이 표시되지 않아요."
                        },
                    };

                    return Promise.all([targetToken, data]).then(result => {
                        admin.messaging().sendToDevice(targetToken, payload).then((response) => {
                            response.results.forEach((result, index) => {
                                const error = result.error
    
                                if(error){
                                    console.error("FCM Failed : ", error.code);
                                }
                            })
                        })
                    })
                })
            }

            else if(new_status == ""){
                const Manager = data.Manager;

                return admin.firestore().collection("Users").doc(Manager).get().then((value) => {
                    targetToken = value.data().token;

                    const payload = {
                        notification : {
                            title : "소집이 다시 시작되었어요!",
                            body : "소집 목록에 소집이 다시 표시돼요."
                        },
                    };

                    return Promise.all([targetToken, data]).then(result => {
                        admin.messaging().sendToDevice(targetToken, payload).then((response) => {
                            response.results.forEach((result, index) => {
                                const error = result.error
    
                                if(error){
                                    console.error("FCM Failed : ", error.code);
                                }
                            })
                        })
                    })
                })
            }

        }

    })