//
//  CounselorHelper.swift
//  SOZIP
//
//  Created by 하창진 on 2021/09/10.
//

import Foundation
import Firebase

class CounselorHelper : ObservableObject{
    @Published var isProcessing : Bool = true
    @Published var chatContents : [CounselorChatDataModel] = []
    @Published var logList : [CounselorLogDataModel] = []
    @Published var counselorList : [CounselorLogDataModel] = []
    
    let db = Firestore.firestore()
    
    func prepare_chat(docId : String, completion : @escaping(_ result : String?) -> Void){
        var conselorRef : DocumentReference? = nil
        
        db.collection("Consulting").whereField("uid", isEqualTo: Auth.auth().currentUser?.uid ?? "")
            .whereField("targetSOZIP", isEqualTo: docId)
            .getDocuments{(querySnapshot, error) in
                if let error = error{
                    print(error)
                    completion("error")
                    
                    return
                }
                
                else {
                    if querySnapshot != nil{
                        if querySnapshot!.documents.count > 0{
                            for document in querySnapshot!.documents{
                                completion(document.documentID)
                                self.isProcessing = false
                            }
                        }
                        
                        else{
                            conselorRef = self.db.collection("Consulting").addDocument(data: [
                                "uid" : Auth.auth().currentUser?.uid ?? "",
                                "targetSOZIP" : docId,
                                "Manager" : ""
                            ]){error in
                                if let error = error{
                                    print(error)
                                    completion("error")
                                    
                                    return
                                }
                                
                                else{
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "yy/MM/dd kk:mm:ss.SSSS"
                                    
                                    self.db.collection("Consulting").document(conselorRef?.documentID ?? "").collection("Chat").addDocument(data: [
                                        "sender" : "Manager",
                                        "msg_type" : "start",
                                        "dateTime" : formatter.string(from: Date())
                                    ]){error in
                                        if let error = error{
                                            print(error)
                                            completion("error")
                                            
                                            return
                                        }
                                        
                                        else{
                                            completion(conselorRef?.documentID ?? "")
                                            self.isProcessing = false
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    else{
                        conselorRef = self.db.collection("Consulting").addDocument(data: [
                            "uid" : Auth.auth().currentUser?.uid ?? "",
                            "targetSOZIP" : docId
                        ]){error in
                            if let error = error{
                                print(error)
                                completion("error")
                                
                                return
                            }
                            
                            else{
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yy/MM/dd kk:mm:ss.SSSS"
                                
                                self.db.collection("Consulting").document(conselorRef?.documentID ?? "").collection("Chat").addDocument(data: [
                                    "sender" : "Manager",
                                    "msg_type" : "start",
                                    "dateTime" : formatter.string(from: Date())
                                ]){error in
                                    if let error = error{
                                        print(error)
                                        completion("error")
                                        
                                        return
                                    }
                                    
                                    else{
                                        completion(conselorRef?.documentID ?? "")
                                        self.isProcessing = false
                                    }
                                }
                            }
                        }
                    }
                }
            }
    }
    
    func getChatList(docId : String, completion: @escaping(_ result : String?) -> Void){
        let chatRef = db.collection("Consulting").document(docId).collection("Chat")
        
        chatRef.order(by: "dateTime", descending: false).addSnapshotListener{(querySnapshot, error) in
            if let error = error{
                print(error)
                completion("error")
                
                return
            }
            
            else{
                querySnapshot?.documentChanges.forEach{diff in
                    if diff.type == .added || diff.type == .modified{
                        let dateTime = diff.document.get("dateTime") as? String ?? ""
                        let sender = diff.document.get("sender") as? String ?? ""
                        let msg_type = diff.document.get("msg_type") as? String ?? ""
                        let msg = AES256Util.decrypt(encoded: diff.document.get("msg") as? String ?? "")
                        let docId = diff.document.documentID ?? ""
                        
                        if !self.chatContents.contains(where: {$0.docId == docId}){
                            self.chatContents.append(CounselorChatDataModel(docId: docId, msg: msg, msg_type: msg_type, sender: sender, dateTime: dateTime))
                        }
                    }
                }
            }
        }
    }
    
    func sendPlainText(msg : String, docId : String, completion : @escaping(_ result : String?) -> Void){
        let chatRef = db.collection("Consulting").document(docId).collection("Chat")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy/MM/dd kk:mm:ss.SSSS"
        
        chatRef.document().setData([
            "dateTime" : dateFormatter.string(from: Date()),
            "msg" : AES256Util.encrypt(string: msg),
            "msg_type" : "text",
            "sender" : Auth.auth().currentUser?.uid ?? ""
        ]){error in
            if let error = error{
                print(error)
                completion("error")
            }
            
            else{
                completion("success")
            }
        }
    }
    
    func getAdminCounselors(completion : @escaping(_ result : String?) -> Void){
        let counselorQuery = db.collection("Consulting").whereField("Manager", isEqualTo: Auth.auth().currentUser?.uid ?? "")
        
        counselorQuery.getDocuments(){(querySnapshot, error) in
            if let error = error{
                print(error)
                completion("error")
                
                return
            }
            
            else{
                for document in querySnapshot!.documents{
                    let docId = document.documentID
                    let target = document.data()["targetSOZIP"] as? String ?? ""
                    
                    let chatRef = self.db.collection("Consulting").document(docId).collection("Chat")
                    
                    chatRef.order(by: "dateTime", descending: true).limit(to: 1).getDocuments(){(querySnapshot, error) in
                        if let error = error{
                            print(error)
                            completion("error")
                            
                            return
                        }
                        
                        else{
                            if querySnapshot != nil{
                                if querySnapshot!.count > 0{
                                    for document in querySnapshot!.documents{
                                        let msg = AES256Util.decrypt(encoded: document.data()["msg"] as? String ?? "")
                                        let msg_type = document.data()["msg_type"] as? String ?? ""
                                        let dateTime = document.data()["dateTime"] as? String ?? ""
                                        
                                        if target != ""{
                                            let docRef = self.db.collection("SOZIP").document(target)
                                            
                                            docRef.getDocument(){(document, error) in
                                                if let error = error{
                                                    print(error)
                                                    completion("error")
                                                    
                                                    return
                                                }
                                                
                                                else{
                                                    let SOZIPName = AES256Util.decrypt(encoded: document?.get("name") as? String ?? "")
                                                    
                                                    if !self.logList.contains(where : {$0.docId == docId}){
                                                        self.logList.append(CounselorLogDataModel(docId: docId, last_msg: msg, last_msg_type: msg_type, last_msg_date: dateTime, SOZIPName: SOZIPName, SOZIPId : target))
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                }
            }
        }
    }
    
    func getAllCounselors(completion : @escaping(_ result : String?) -> Void){
        let counselorRef = db.collection("Consulting").whereField("Manager", isEqualTo: "")
        
        counselorRef.getDocuments(){(querySnapshot, error) in
            if let error = error{
                print(error)
                completion("error")
                
                return
            }
            
            else{
                if querySnapshot != nil{
                    for document in querySnapshot!.documents{
                        let docId = document.documentID
                        let target = document.data()["targetSOZIP"] as? String ?? ""
                        
                        let chatRef = self.db.collection("Consulting").document(docId).collection("Chat")
                        
                        chatRef.order(by: "dateTime", descending: true).limit(to: 1).getDocuments(){(querySnapshot, error) in
                            if let error = error{
                                print(error)
                                completion("error")
                                
                                return
                            }
                            
                            else{
                                if querySnapshot != nil{
                                    if querySnapshot!.count > 0{
                                        for document in querySnapshot!.documents{
                                            let msg = AES256Util.decrypt(encoded: document.data()["msg"] as? String ?? "")
                                            let msg_type = document.data()["msg_type"] as? String ?? ""
                                            let dateTime = document.data()["dateTime"] as? String ?? ""
                                            
                                            if target != ""{
                                                let docRef = self.db.collection("SOZIP").document(target)
                                                
                                                docRef.getDocument(){(document, error) in
                                                    if let error = error{
                                                        print(error)
                                                        completion("error")
                                                        
                                                        return
                                                    }
                                                    
                                                    else{
                                                        let SOZIPName = AES256Util.decrypt(encoded: document?.get("name") as? String ?? "")
                                                        
                                                        if !self.counselorList.contains(where : {$0.docId == docId}){
                                                            self.counselorList.append(CounselorLogDataModel(docId: docId, last_msg: msg, last_msg_type: msg_type, last_msg_date: dateTime, SOZIPName: SOZIPName, SOZIPId : target))
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getCounselorLog(completion : @escaping(_ result : String?) -> Void){
        let counselorQuery = db.collection("Consulting").whereField("uid", isEqualTo: Auth.auth().currentUser?.uid ?? "")
        
        counselorQuery.getDocuments(){(querySnapshot, error) in
            if let error = error{
                print(error)
                completion("error")
                
                return
            }
            
            else{
                for document in querySnapshot!.documents{
                    let docId = document.documentID
                    let target = document.data()["targetSOZIP"] as? String ?? ""
                    
                    let chatRef = self.db.collection("Consulting").document(docId).collection("Chat")
                    
                    chatRef.order(by: "dateTime", descending: true).limit(to: 1).getDocuments(){(querySnapshot, error) in
                        if let error = error{
                            print(error)
                            completion("error")
                            
                            return
                        }
                        
                        else{
                            if querySnapshot != nil{
                                if querySnapshot!.count > 0{
                                    for document in querySnapshot!.documents{
                                        let msg = AES256Util.decrypt(encoded: document.data()["msg"] as? String ?? "")
                                        let msg_type = document.data()["msg_type"] as? String ?? ""
                                        let dateTime = document.data()["dateTime"] as? String ?? ""
                                        
                                        if target != ""{
                                            let docRef = self.db.collection("SOZIP").document(target)
                                            
                                            docRef.getDocument(){(document, error) in
                                                if let error = error{
                                                    print(error)
                                                    completion("error")
                                                    
                                                    return
                                                }
                                                
                                                else{
                                                    let SOZIPName = AES256Util.decrypt(encoded: document?.get("name") as? String ?? "")
                                                    
                                                    if !self.logList.contains(where : {$0.docId == docId}){
                                                        self.logList.append(CounselorLogDataModel(docId: docId, last_msg: msg, last_msg_type: msg_type, last_msg_date: dateTime, SOZIPName: SOZIPName, SOZIPId : target))
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                }
            }
        }
    }
}
