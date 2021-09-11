//
//  FeedbackHubHelper.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/30.
//

import Foundation
import Firebase
import SwiftyJSON

class FeedbackHubHelper : ObservableObject{
    private let db = Firestore.firestore()
    private let uid = Auth.auth().currentUser?.uid ?? ""
    private let functions = Functions.functions()
    
    @Published var list : [FeedbackHubItemModel] = []
    @Published var managerList : [FeedbackHubItemModel] = []
    
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
        formatter.dateFormat = "yy/MM/dd HH:mm:ss"
        let date_str = formatter.string(from: Date())
        
        let docRef = db.collection("Feedbacks").document()
        
        let data = [
            "category" : category_string,
            "title" : title,
            "contents" : contents,
            "author" : Auth.auth().currentUser?.uid ?? "",
            "date" : date_str,
            "answer" : ""
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
        
        let docQuery = db.collection("Feedbacks").whereField("author", isEqualTo: self.uid)
        
        docQuery.getDocuments(){(querySnapshot, error) in
            if let error = error{
                print(error)
                completion(.error)
                return
            }
            
            else{
                for document in querySnapshot!.documents{
                    let docId = document.documentID

                    if !self.list.contains(where : {$0.docId == docId}){
                        let category = document.data()["category"] as? String ?? ""
                        let contents = document.data()["contents"] as? String ?? ""
                        let date = document.data()["date"] as? String ?? ""
                        let title = document.data()["title"] as? String ?? ""
                        let answer = document.data()["answer"] as! String?
                        
                        self.list.append(FeedbackHubItemModel(title: title, contents: contents, category: category, date: date, answer: answer, docId: docId))
                    }
                }
                
                self.list.sort(by: {$0.date > $1.date})
            }
        }
    }
    
    func getAllFeedbacks(completion : @escaping(_ result : FeedbackHubErrorModel?) -> Void){
        if self.uid == nil || self.uid == ""{
            completion(.noUser)
            
            return
        }
        
        else{
            UserManagement().getAdminInfo(){result in
                guard let result = result else{
                    completion(.error)
                    return
                }
                
                if result == "true"{
                    let feedbackQuery = self.db.collection("Feedbacks")
                    
                    feedbackQuery.getDocuments(){(querySnapshot, error) in
                        if error != nil{
                            completion(.error)
                            
                            return
                        }
                        
                        else{
                            self.functions.httpsCallable("getFeedbacks").call(){result, error in
                                if let error = error{
                                    completion(.error)
                                    print(error)
                                    
                                    return
                                }
                                
                                else{
                                    if let data = result?.data as? [String : Any]{
                                        self.list.removeAll()
                                        
                                        let json = JSON(data)
                                        
                                        for (key, value) in data{
                                            let value = json[key]
                                            
                                            if !self.managerList.contains(where : {$0.docId == key}){
                                                self.managerList.append(FeedbackHubItemModel(title: value["title"].string ?? "", contents: value["contents"].string ?? "", category: value["category"].string ?? "", date: value["date"].string ?? "", answer: value["answer"].string ?? nil, docId : key))
                                            }
                                        }
                                        
                                        self.managerList.sort(by: {$0.date > $1.date})
                                    }
                                    
                                    completion(.success)
                                }
                            }
                        }
                    }
                }
                
                else{
                    completion(.noUser)
                }
            }
        }
    }
    
    func sendAnswer(answer : String, docId : String, completion : @escaping(_ result : String?) -> Void){
        if self.uid == nil || self.uid == ""{
            completion("noPermission")
            
            return
        }
        
        else{
            UserManagement().getAdminInfo(){result in
                guard let result = result else{
                    completion("noPermission")
                    return
                }
                
                if result == "true"{
                    let feedbackQuery = self.db.collection("Feedbacks")
                    
                    feedbackQuery.getDocuments(){(querySnapshot, error) in
                        if error != nil{
                            completion("error")
                            
                            print(error)
                            
                            return
                        }
                        
                        else{
                            self.functions.httpsCallable("addAnswer").call(["answer" : answer, "docId" : docId]){result, error in
                                if let error = error{
                                    completion("error")
                                    print(error)
                                    
                                    return
                                }
                                
                                else{
                                    if let data = result?.data as? [String : Any]{
                                        let result = data["status"] as? String ?? ""
                                        
                                        if result == "success"{
                                            completion("success")
                                        }
                                        
                                        else{
                                            completion("fail")
                                        }
                                        
                                    }
                                    
                                    else{
                                        print("error")
                                        completion("error")
                                    }
                                    
                                }
                            }
                        }
                    }
                }
                
                else{
                    completion("noPermission")
                }
            }
        }
    }
}
