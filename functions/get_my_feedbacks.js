const functions = require("firebase-functions");
const admin = require("firebase-admin");

function struct_feedback(){
    var title, contents, date, category, read, answer;
}

exports.get_my_feedbacks = functions.https.onCall((data, context) =>{
    const uid = context.auth.uid;
    var db = admin.firestore();
    var result = [];

    var feedbackRef = db.collection('Feedbacks');
    feedbackRef.get().then(snapshot => {
            snapshot.forEach(doc => {
                const feedback = feedbackRef.doc(doc.id);

                feedback.get().then((queryResult) => {
                    const author = queryResult.data().author;

                    if(author == uid){
                        var str = new struct_feedback();
                        str.title = queryResult.data().title;
                        str.contents = queryResult.data().contents;
                        str.date = queryResult.data().date;
                        str.category = queryResult.data().category;
                        str.read = queryResult.data().read || null;
                        str.answer = queryResult.data().answer || null;

                        result.push(str);
                    }
                })
            })
        });

        return result;
})