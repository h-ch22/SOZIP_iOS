//
//  SOZIPHelper.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/02.
//

import Foundation
import Firebase
import SwiftUI
import Alamofire

class SOZIPHelper : ObservableObject{
    private let db = Firestore.firestore()
    private let nickName = AES256Util.decrypt(encoded:UserDefaults.standard.string(forKey: "nickName") ?? "")
    @Published var SOZIPList : [SOZIPDataModel] = []
    
    func addSOZIP(name : String, storeName : String, receiver : SOZIPLocationReceiver, dateTime : Date, Color : Color, tags : [String], completion : @escaping(_ result : Bool?) -> Void){
        let docRef = db.collection("SOZIP").document()
        var colorName = ""
        
        switch Color{
        case .sozip_bg_1 :
            colorName = "bg_1"
            
        case .sozip_bg_2 :
            colorName = "bg_2"
            
        case .sozip_bg_3:
            colorName = "bg_3"
            
        case .sozip_bg_4:
            colorName = "bg_4"
            
        case .sozip_bg_5:
            colorName = "bg_5"
            
        default:
            colorName = "bg_1"
        }
        
        let currentTime = Date()
        
        let data : [String : Any] = [
            "name" : AES256Util.encrypt(string: name),
            "storeName" : AES256Util.encrypt(string:storeName),
            "location" : AES256Util.encrypt(string:receiver.location),
            "address" : AES256Util.encrypt(string: receiver.address),
            "description" : AES256Util.encrypt(string:receiver.description),
            "dateTime" : dateTime,
            "tags" : tags,
            "Color" : colorName,
            "Manager" :Auth.auth().currentUser?.uid as! String,
            "participants" : [Auth.auth().currentUser?.uid as! String : nickName],
            "payMethod" : [Auth.auth().currentUser?.uid as! String : ""],
            "transactionMethod" : [Auth.auth().currentUser?.uid as! String : ""],
            "last_msg" : AES256Util.encrypt(string: "소집이 시작되었어요!"),
            "last_msg_type" : "participate",
            "last_msg_time" : currentTime
        ]
        
        docRef.setData(data){error in
            if let error = error{
                print(error)
                completion(false)
            }
            
            else{
                let chatRef = docRef.collection("Chat").document()
                
                let chatData : [String : Any] = [
                    "msg" : AES256Util.encrypt(string: "소집이 시작되었어요!"),
                    "msg_type" : "participate",
                    "sender" : Auth.auth().currentUser?.uid as! String,
                    "date" : currentTime,
                    "unread" : []
                ]
                
                chatRef.setData(chatData){error in
                    if let error = error{
                        print(error)
                        completion(false)
                    }
                    
                    else{
                        completion(true)
                    }
                }
            }
        }
    }
    
    func getSOZIP(completion : @escaping(_ result : Bool?) -> Void){
        let collectionRef = db.collection("SOZIP")
        
        collectionRef.addSnapshotListener{querySnapshot, error in
            if let error = error{
                print(error)
            }
            
            else{
                querySnapshot?.documentChanges.forEach{ diff in
                    if(diff.type == .added){
                        let Color = diff.document.get("Color") as? String ?? "bg_1"
                        let address = diff.document.get("address") as? String ?? ""
                        let dateTime = diff.document.get("dateTime") as? Date ?? Date()
                        let description = diff.document.get("description") as? String ?? ""
                        let location = diff.document.get("location") as? String ?? ""
                        let name = diff.document.get("name") as? String ?? ""
                        let storeName = diff.document.get("storeName") as? String ?? ""
                        let tags = diff.document.get("tags") as? [String] ?? []
                        let currentPeople = diff.document.get("currentPeople") as? Int ?? 1
                        var color : Color = .sozip_bg_1
                        let docId = diff.document.documentID
                        let participants = diff.document.get("participants") as? [String : String] ?? [:]
                        let Manager = diff.document.get("Manager") as? String ?? ""
                        let status = diff.document.get("status") as? String ?? ""
                        let payMethod = diff.document.get("payMethod") as? [String : String] ?? [:]
                        let transactionMethod = diff.document.get("transactionMethod") as? [String : String] ?? [:]
                        
                        switch(Color){
                        case "bg_1":
                            color = .sozip_bg_1
                            
                        case "bg_2":
                            color = .sozip_bg_2
                            
                        case "bg_3":
                            color = .sozip_bg_3
                            
                        case "bg_4":
                            color = .sozip_bg_4
                            
                        case "bg_5":
                            color = .sozip_bg_5
                            
                        default:
                            color = .sozip_bg_1
                        }
                        
                        if !self.SOZIPList.contains(where : {($0.docId == docId)}){
                            self.SOZIPList.append(
                                                    SOZIPDataModel(
                                                        docId : docId,
                                                        tags: tags,
                                                        SOZIPName: AES256Util.decrypt(encoded: name),
                                                        currentPeople: currentPeople,
                                                        location_description: AES256Util.decrypt(encoded: description),
                                                        SOZIP_Color: color,
                                                        store: AES256Util.decrypt(encoded: storeName),
                                                        time: dateTime,
                                                        Manager : Manager,
                                                        participants : participants,
                                                        location: AES256Util.decrypt(encoded:location),
                                                        address: AES256Util.decrypt(encoded:address),
                                                        status: status,
                                                        payMethod: payMethod,
                                                        transactionMethod: transactionMethod)
                            )
                        }
                    }
                    
                    else if (diff.type == .modified){
                        let Color = diff.document.get("Color") as? String ?? "bg_1"
                        let address = diff.document.get("address") as? String ?? ""
                        let dateTime = diff.document.get("dateTime") as? Date ?? Date()
                        let description = diff.document.get("description") as? String ?? ""
                        let location = diff.document.get("location") as? String ?? ""
                        let name = diff.document.get("name") as? String ?? ""
                        let storeName = diff.document.get("storeName") as? String ?? ""
                        let tags = diff.document.get("tags") as? [String] ?? []
                        let currentPeople = diff.document.get("currentPeople") as? Int ?? 1
                        var color : Color = .sozip_bg_1
                        let docId = diff.document.documentID
                        let participants = diff.document.get("participants") as? [String : String] ?? [:]
                        let Manager = diff.document.get("Manager") as? String ?? ""
                        let status = diff.document.get("status") as? String ?? ""
                        let payMethod = diff.document.get("payMethod") as? [String : String] ?? [:]
                        let transactionMethod = diff.document.get("transactionMethod") as? [String : String] ?? [:]
                        
                        switch(Color){
                        case "bg_1":
                            color = .sozip_bg_1
                            
                        case "bg_2":
                            color = .sozip_bg_2
                            
                        case "bg_3":
                            color = .sozip_bg_3
                            
                        case "bg_4":
                            color = .sozip_bg_4
                            
                        case "bg_5":
                            color = .sozip_bg_5
                            
                        default:
                            color = .sozip_bg_1
                        }
                        
                        let data = SOZIPDataModel(
                            docId : docId,
                            tags: tags,
                            SOZIPName: AES256Util.decrypt(encoded: name),
                            currentPeople: currentPeople,
                            location_description: AES256Util.decrypt(encoded: description),
                            SOZIP_Color: color,
                            store: AES256Util.decrypt(encoded: storeName),
                            time: dateTime,
                            Manager: Manager,
                            participants: participants,
                            location: AES256Util.decrypt(encoded:location),
                            address: AES256Util.decrypt(encoded:address),
                            status: status,
                            payMethod: payMethod,
                            transactionMethod: transactionMethod)
                        
                        let index = self.SOZIPList.firstIndex(where : {$0.docId == docId})
                        
                        print(index ?? "cannot find document.")

                        if index != nil{
                            self.SOZIPList.remove(at: index!)
                            self.SOZIPList.append(data)
                        }
                        
                    }
                    
                    else if (diff.type == .removed){
                        var docId = diff.document.documentID
                        
                        let index = self.SOZIPList.firstIndex(where: {$0.docId == docId})
                        
                        if index != nil{
                            self.SOZIPList.remove(at: index!)
                        }
                    }
                }
                
                self.SOZIPList.sort{
                    $0.time > $1.time
                }
            }
        }
        
        collectionRef.getDocuments(){(querySnapshot, error) in
            if let error = error{
                print(error)
                
                completion(false)
            }
            
            else{
                for document in querySnapshot!.documents{
                    let SOZIPRef = self.db.collection("SOZIP").document(document.documentID)
                    
                    SOZIPRef.getDocument(){(document, error) in
                        if let error = error{
                            print(error)
                            
                            completion(false)
                        }
                        
                        else{
                            let Color = document!.get("Color") as? String ?? "bg_1"
                            let address = document!.get("address") as? String ?? ""
                            let dateTime = document!.get("dateTime") as? Date ?? Date()
                            let description = document!.get("description") as? String ?? ""
                            let location = document!.get("location") as? String ?? ""
                            let name = document!.get("name") as? String ?? ""
                            let storeName = document!.get("storeName") as? String ?? ""
                            let tags = document!.get("tags") as? [String] ?? []
                            let currentPeople = document!.get("currentPeople") as? Int ?? 1
                            var color : Color = .sozip_bg_1
                            let docId = document?.documentID
                            let participants = document!.get("participants") as? [String : String] ?? [:]
                            let Manager = document!.get("Manager") as? String ?? ""
                            let status = document!.get("status") as? String ?? ""
                            let payMethod = document!.get("payMethod") as? [String : String] ?? [:]
                            let transactionMethod = document!.get("transactionMethod") as? [String : String] ?? [:]
                            
                            switch(Color){
                            case "bg_1":
                                color = .sozip_bg_1
                                
                            case "bg_2":
                                color = .sozip_bg_2
                                
                            case "bg_3":
                                color = .sozip_bg_3
                                
                            case "bg_4":
                                color = .sozip_bg_4
                                
                            case "bg_5":
                                color = .sozip_bg_5
                                
                            default:
                                color = .sozip_bg_1
                            }
                            
                            if !self.SOZIPList.contains(where : {($0.docId == docId)}){
                                self.SOZIPList.append(
                                                        SOZIPDataModel(
                                                            docId : docId!,
                                                            tags: tags,
                                                            SOZIPName: AES256Util.decrypt(encoded: name),
                                                            currentPeople: currentPeople,
                                                            location_description: AES256Util.decrypt(encoded: description),
                                                            SOZIP_Color: color,
                                                            store: AES256Util.decrypt(encoded: storeName),
                                                            time: dateTime,
                                                            Manager: Manager,
                                                            participants: participants,
                                                            location: AES256Util.decrypt(encoded:location),
                                                            address: AES256Util.decrypt(encoded:address),
                                                            status : status,
                                                            payMethod: payMethod,
                                                            transactionMethod: transactionMethod)
                                )
                            }
                            

                        }
                    }
                }
                
                self.SOZIPList.sort{
                    $0.time > $1.time
                }
            }
        }
    }
    
    func participate_SOZIP(method : String, docId : String, position : String, payMethod : String, transactionMethod : String, completion : @escaping(_ result : String?) -> Void){
        let SOZIPRef = db.collection("SOZIP").document(docId)
        
        SOZIPRef.getDocument(){(document, error) in
            if let error = error{
                completion("error")
                print(error)
                return
            }
            
            else{
                if document != nil{
                    let participants = document!.get("participants") as? [String : String] ?? [:]
                    let uidArray = [Auth.auth().currentUser?.uid as! String : self.nickName]
                    
                    if participants.keys.contains(Auth.auth().currentUser?.uid as! String){
                        completion("already_participated")
                        return
                    }
                    
                    else{
                        SOZIPRef.updateData([
                            "participants.\(Auth.auth().currentUser?.uid as! String)" : self.nickName,
                            "payMethod.\(Auth.auth().currentUser?.uid as! String)" : payMethod,
                            "transactionMethod.\(Auth.auth().currentUser?.uid as! String)" : transactionMethod
                        ]){error in
                            if let error = error{
                                print(error)
                                completion("error")
                                return
                            }
                            
                            else{
                                let currentTime = Date()
                                let chatRef = SOZIPRef.collection("Chat").document()
                                
                                let chatData : [String : Any] = [
                                    "msg" : AES256Util.encrypt(string: self.nickName + "님이 참여했어요!!"),
                                    "msg_type" : "participate",
                                    "sender" : Auth.auth().currentUser?.uid as! String,
                                    "date" : currentTime,
                                    "unread" : []
                                ]
                                
                                chatRef.setData(chatData){error in
                                    if let error = error{
                                        print(error)
                                        completion("error")
                                    }
                                    
                                    else{
                                        completion("success")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func exit_SOZIP(docId : String, completion : @escaping(_ result : String?) -> Void){
        let SOZIPRef = db.collection("SOZIP").document(docId)
        
        SOZIPRef.getDocument(){(document, error) in
            if let error = error{
                print(error)
                completion("error")
                return
            }
            
            else{
                if document != nil{
                    let participants = document!.get("participants") as? [String : String] ?? [:]
                    
                    if participants.keys.contains(Auth.auth().currentUser?.uid ?? ""){
                        SOZIPRef.updateData(["participants.\(Auth.auth().currentUser?.uid as! String)" : FieldValue.delete()]){error in
                            if let error = error{
                                completion("erorr")
                                return
                            }
                            
                            else{
                                completion("success")
                                return
                            }
                        }
                        
                    }
                    
                    else{
                        completion("already_exit")
                        return
                    }
                }
            }
        }
    }
    
    func close_SOZIP(docId : String, completion : @escaping(_ result : String?) -> Void){
        let SOZIPRef = db.collection("SOZIP").document(docId)
        
        SOZIPRef.getDocument(){(document, error) in
            if let error = error{
                completion("error")
                print(error)
                return
            }
            
            else{
                if document != nil{
                    let status = document!.get("status") as? String ?? ""
                    
                    if status == ""{
                        SOZIPRef.updateData(["status" : "closed"]){error in
                            if let error = error{
                                completion("error")
                                print(error)
                                return
                            }
                            
                            else{
                                completion("success")
                            }
                        }
                    }
                    
                    else if status == "closed"{
                        completion("already_closed")
                    }
                }
            }
        }
    }
    
    func changeInformation(docId : String, payMethod : String, transactionMethod : String, completion : @escaping(_ result : String?) -> Void){
        let SOZIPRef = db.collection("SOZIP").document(docId)
        
        if Auth.auth().currentUser == nil{
            completion("error")
            return
        }
        
        SOZIPRef.updateData(["payMethod.\(Auth.auth().currentUser?.uid as! String)" : payMethod,
                             "transactionMethod.\(Auth.auth().currentUser?.uid as! String)" : transactionMethod]){error in
            if let error = error{
                print(error)
                completion("error")
                return
            }
            
            else{
                completion("success")
            }
        }
    }
    
    func pauseSOZIP(docId : String, completion : @escaping(_ result : String?) -> Void){
        let SOZIPRef = db.collection("SOZIP").document(docId)
        
        SOZIPRef.updateData(["status" : "paused"]){error in
            if let error = error{
                print(error)
                completion("error")
                
                return
            }
            
            else{
                completion("success")
            }
        }
    }
    
    func resumeSOZIP(docId : String, completion : @escaping(_ result : String?) -> Void){
        let SOZIPRef = db.collection("SOZIP").document(docId)
        
        SOZIPRef.updateData(["status" : ""]){error in
            if let error = error{
                print(error)
                completion("error")
                
                return
            }
            
            else{
                completion("success")
            }
        }
    }
}
