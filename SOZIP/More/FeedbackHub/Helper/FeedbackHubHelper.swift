//
//  FeedbackHubHelper.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/30.
//

import Foundation
import Firebase

class FeedbackHubHelper : ObservableObject{
    private let db = Firestore.firestore()
    private let uid = Auth.auth().currentUser?.uid ?? ""
    private let functions = Functions.functions()
    @Published var list : [FeedbackHubItemModel] = []
    
    func sendFeedback(category : FeedbackHubCategoryModel, title : String, contents : String, completion : @escaping(_ result : FeedbackHubErrorModel?) -> Void){
        if self.uid == nil || self.uid == ""{
            completion(.noUser)
            return
        }
        
        var category_string = ""
        
        switch(category){
        case .heart:
            category_string = "칭찬해요"
            
        case .improve:
            category_string = "개선해주세요"
            
        case .question:
            category_string = "궁금해요"
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd. HH:mm:ss"
        let date_str = formatter.string(from: Date())
        
        let docRef = db.collection("Feedbacks").document(self.uid + "_" + date_str)
        
        let data = [
            "category" : category_string,
            "title" : title,
            "contents" : contents,
            "author" : Auth.auth().currentUser?.uid ?? "",
            "date" : Date()
        ] as [String : Any]
        
        docRef.setData(data){err in
            if let err = err{
                print(err)
                completion(.error)
                return
            }
            
            else{
                completion(.success)
                return
            }
        }
    }
    
    func getFeedback(completion : @escaping(_ result : FeedbackHubErrorModel?) -> Void){
        if self.uid == nil || self.uid == ""{
            completion(.noUser)
            return
        }
        
        functions.httpsCallable("get_my_feedbacks").call(){result, error in
            if let error = error{
                print(error)
            }
            
            if let data = result?.data as? [String : Any]{
                print("receiving data...")
                print(data)
            }
            
            else{
                print("no data")
            }
        }
    }
}
