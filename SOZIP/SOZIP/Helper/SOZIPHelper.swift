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
    @Published var SingleSOZIPModel : SOZIPDataModel? = nil
    @Published var categoryList : [String] = []
    
    func addSOZIP(name : String, receiver : SOZIPLocationReceiver, dateTime : Date, color : Color, account : String, url : String, category : String, firstCome : Int, type : SOZIPPackagingTypeModel, completion : @escaping(_ result : Bool?) -> Void){
        let docRef = db.collection("SOZIP").document()
        
        let currentTime = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy/MM/dd HH:mm:ss.SSSS"
        let date_string = dateFormatter.string(from: dateTime)
        
        var color_string = ""
        
        switch color{
        case .sozip_bg_1:
            color_string = "bg_1"
            
        case .sozip_bg_2:
            color_string = "bg_2"
            
        case .sozip_bg_3:
            color_string = "bg_3"
            
        case .sozip_bg_4:
            color_string = "bg_4"
            
        case .sozip_bg_5:
            color_string = "bg_5"
            
        default:
            color_string = "bg_1"
        }
        
        let data : [String : Any] = [
            "name" : AES256Util.encrypt(string: name),
            "location" : AES256Util.encrypt(string:receiver.location),
            "address" : AES256Util.encrypt(string: receiver.address),
            "description" : AES256Util.encrypt(string:receiver.description),
            "dateTime" : dateFormatter.date(from: date_string),
            "category" : category ?? "",
            "firstCome" : firstCome ?? nil,
            "Manager" :Auth.auth().currentUser?.uid as! String,
            "participants" : [Auth.auth().currentUser?.uid as! String : nickName],
            "payMethod" : [Auth.auth().currentUser?.uid as! String : ""],
            "transactionMethod" : [Auth.auth().currentUser?.uid as! String : ""],
            "last_msg" : AES256Util.encrypt(string: "소집이 시작되었어요!"),
            "profiles" : [Auth.auth().currentUser?.uid as! String : UserDefaults.standard.string(forKey: "profile")! + "," + UserDefaults.standard.string(forKey: "profile_bg")!],
            "last_msg_type" : "participate",
            "color" : color_string,
            "last_msg_time" : dateFormatter.string(from: currentTime),
            "account" : account,
            "url" : url,
            "type" : type == .DELIVERY ? "DELIVERY" : "TAKE_OUT"
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
                    "date" : dateFormatter.string(from: currentTime),
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
    
//    func getSpecificSOZIP(docId : String, completion : @escaping(_ result : Bool?) -> Void){
//        let SOZIPRef = db.collection("SOZIP").document(docId)
//        
//        SOZIPRef.getDocument(){(document, error) in
//            if let error = error{
//                print(error)
//                completion(false)
//                
//                return
//            }
//            
//            else{
//                let address = document?.get("address") as? String ?? ""
//                let date = document?.get("dateTime") as! Timestamp
//                let description = document?.get("description") as? String ?? ""
//                let location = document?.get("location") as? String ?? ""
//                let name = document?.get("name") as? String ?? ""
//                let tags = document?.get("tags") as? [String] ?? []
//                let currentPeople = document?.get("currentPeople") as? Int ?? 1
//                let participants = document?.get("participants") as? [String : String] ?? [:]
//                let Manager = document?.get("Manager") as? String ?? ""
//                let status = document?.get("status") as? String ?? ""
//                let payMethod = document?.get("payMethod") as? [String : String] ?? [:]
//                let transactionMethod = document?.get("transactionMethod") as? [String : String] ?? [:]
//                let dateTime = date.dateValue()
//                let color = document?.get("color") as? String ?? "bg_1"
//                
//                var colorCode : Color = .sozip_bg_1
//                
//                switch color{
//                    case "bg_1":
//                    colorCode = .sozip_bg_1
//                    
//                case "bg_2":
//                    colorCode = .sozip_bg_2
//                    
//                case "bg_3":
//                    colorCode = .sozip_bg_3
//                    
//                case "bg_4":
//                    colorCode = .sozip_bg_4
//                    
//                case "bg_5":
//                    colorCode = .sozip_bg_5
//                    
//                default:
//                    colorCode = .sozip_bg_1
//                }
//                
//                let formatter = DateFormatter()
//                formatter.dateFormat = "yyyy. MM. dd kk:mm:ss.SSSS"
//                
//                self.SingleSOZIPModel = SOZIPDataModel(docId: docId,
//                                                       tags: tags,
//                                                       SOZIPName: AES256Util.decrypt(encoded : name),
//                                                       currentPeople: currentPeople,
//                                                       location_description: AES256Util.decrypt(encoded : description),
//                                                       time: dateTime,
//                                                       Manager: Manager,
//                                                       participants: participants,
//                                                       location: AES256Util.decrypt(encoded : location),
//                                                       address: AES256Util.decrypt(encoded : address),
//                                                       status: status,
//                                                       payMethod: payMethod,
//                                                       transactionMethod: transactionMethod,
//                                                       color: colorCode)
//            }
//        }
//    }
    
    func getSOZIP(completion : @escaping(_ result : Bool?) -> Void){
        let collectionRef = db.collection("SOZIP")
        
        collectionRef.addSnapshotListener{querySnapshot, error in
            if let error = error{
                print(error)
            }
            
            else{
                querySnapshot?.documentChanges.forEach{ diff in
                    if(diff.type == .added){
                        let address = diff.document.get("address") as? String ?? ""
                        let date = diff.document.get("dateTime") as! Timestamp
                        let description = diff.document.get("description") as? String ?? ""
                        let location = diff.document.get("location") as? String ?? ""
                        let name = diff.document.get("name") as? String ?? ""
                        let category = diff.document.get("category") as? String ?? ""
                        let firstCome = diff.document.get("firstCome") as? Int ?? 4
                        let currentPeople = diff.document.get("currentPeople") as? Int ?? 1
                        let docId = diff.document.documentID
                        let participants = diff.document.get("participants") as? [String : String] ?? [:]
                        let Manager = diff.document.get("Manager") as? String ?? ""
                        let status = diff.document.get("status") as? String ?? ""
                        let dateTime = date.dateValue()
                        let color = diff.document.get("color") as? String ?? "bg_1"
                        let account = diff.document.get("account") as? String ?? ""
                        let profile = diff.document.get("profiles") as? [String : String] ?? [:]
                        var colorCode : Color = .sozip_bg_1
                        let url = diff.document.get("url") as! String?
                        let type = diff.document.get("type") as? String ?? "DELIVERY"
                        
                        switch color{
                        case "bg_1":
                            colorCode = .sozip_bg_1
                            
                        case "bg_2":
                            colorCode = .sozip_bg_2
                            
                        case "bg_3":
                            colorCode = .sozip_bg_3
                            
                        case "bg_4":
                            colorCode = .sozip_bg_4
                            
                        case "bg_5":
                            colorCode = .sozip_bg_5
                            
                        default:
                            colorCode = .sozip_bg_1
                        }
                        
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy. MM. dd kk:mm:ss.SSSS"
                                                                        
                        if status == "" && !self.categoryList.contains(where : {$0 == category}){
                            self.categoryList.append(category)
                        }
                        
                        if !self.SOZIPList.contains(where : {($0.docId == docId)}){
                            self.SOZIPList.append(
                                                    SOZIPDataModel(
                                                        docId : docId,
                                                        SOZIPName : AES256Util.decrypt(encoded: name),
                                                        currentPeople : currentPeople,
                                                        location_description: AES256Util.decrypt(encoded: description),
                                                        time: dateTime,
                                                        Manager: Manager,
                                                        participants: participants,
                                                        location : AES256Util.decrypt(encoded:location),
                                                        address : AES256Util.decrypt(encoded:address),
                                                        status: status,
                                                        color: colorCode,
                                                        account: account,
                                                        profile : profile,
                                                        url : url,
                                                        category : category,
                                                        firstCome : firstCome,
                                                        type : type == "DELIVERY" ? .DELIVERY : .TAKE_OUT)
                            )
                        }
                    }
                    
                    else if (diff.type == .modified){
                        let Color = diff.document.get("Color") as? String ?? "bg_1"
                        let address = diff.document.get("address") as? String ?? ""
                        let date = diff.document.get("dateTime") as! Timestamp
                        let description = diff.document.get("description") as? String ?? ""
                        let location = diff.document.get("location") as? String ?? ""
                        let name = diff.document.get("name") as? String ?? ""
                        let tags = diff.document.get("tags") as? [String] ?? []
                        let currentPeople = diff.document.get("currentPeople") as? Int ?? 1
                        let docId = diff.document.documentID
                        let participants = diff.document.get("participants") as? [String : String] ?? [:]
                        let Manager = diff.document.get("Manager") as? String ?? ""
                        let status = diff.document.get("status") as? String ?? ""
                        let account = diff.document.get("account") as? String ?? ""
                        let profile = diff.document.get("profiles") as? [String : String] ?? [:]
                        let url = diff.document.get("url") as! String?
                        let category = diff.document.get("category") as? String ?? ""
                        let firstCome = diff.document.get("firstCome") as? Int ?? 4
                        let type = diff.document.get("type") as? String ?? "DELIVERY"
                        
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy. MM. dd kk:mm:ss.SSSS"
                        
                        let dateTime = date.dateValue()
                        
                        let color = diff.document.get("color") as? String ?? "bg_1"

                        var colorCode : Color = .sozip_bg_1
                        
                        switch color{
                        case "bg_1":
                            colorCode = .sozip_bg_1
                            
                        case "bg_2":
                            colorCode = .sozip_bg_2
                            
                        case "bg_3":
                            colorCode = .sozip_bg_3
                            
                        case "bg_4":
                            colorCode = .sozip_bg_4
                            
                        case "bg_5":
                            colorCode = .sozip_bg_5
                            
                        default:
                            colorCode = .sozip_bg_1
                        }
                        
                        let data = SOZIPDataModel(
                            docId : docId,
                            SOZIPName: AES256Util.decrypt(encoded: name),
                            currentPeople: currentPeople,
                            location_description: AES256Util.decrypt(encoded: description),
                            time: dateTime,
                            Manager: Manager,
                            participants: participants,
                            location: AES256Util.decrypt(encoded:location),
                            address: AES256Util.decrypt(encoded:address),
                            status: status,
                            color : colorCode,
                            account : account,
                            profile : profile,
                            url : url,
                            category : category,
                            firstCome : firstCome,
                            type : type == "DELIVERY" ? .DELIVERY : .TAKE_OUT)
                        
                        let index = self.SOZIPList.firstIndex(where : {$0.docId == docId})
                        
                        print(index ?? "cannot find document.")

                        if status == "" && !self.categoryList.contains(where : {$0 == category}){
                            self.categoryList.append(category)
                        }
                        
                        if index != nil{
                            self.SOZIPList.remove(at: index!)
                            self.SOZIPList.append(data)
                        }
                        
                    }
                    
                    else if (diff.type == .removed){
                        let docId = diff.document.documentID
                        
                        let index = self.SOZIPList.firstIndex(where: {$0.docId == docId})
                        
                        if index != nil{
                            self.SOZIPList.remove(at: index!)
                        }
                    }
                }
                
                self.SOZIPList.sort{
                    $0.time < $1.time
                }
            }
        }
    }
    
    func participate_SOZIP(docId : String, position : String, completion : @escaping(_ result : String?) -> Void){
        let SOZIPRef = db.collection("SOZIP").document(docId)
        
        SOZIPRef.getDocument(){(document, error) in
            if let error = error{
                completion("error")
                print(error)
                return
            }
            
            else{
                if document != nil{
                    let currentPeople = document!.get("currentPeople") as? Int ?? 1
                    let limit = document!.get("firstCome") as? Int ?? 4
                    
                    if currentPeople >= limit + 1{
                        completion("limitPeople")
                        return
                    }
                    
                    let participants = document!.get("participants") as? [String : String] ?? [:]
                    let uidArray = [Auth.auth().currentUser?.uid as! String : self.nickName]
                    
                    if participants.keys.contains(Auth.auth().currentUser?.uid as! String){
                        completion("already_participated")
                        return
                    }
                    
                    else{
                        SOZIPRef.updateData([
                            "participants.\(Auth.auth().currentUser?.uid as! String)" : self.nickName,
                            "profiles.\(Auth.auth().currentUser?.uid as! String)" :  UserDefaults.standard.string(forKey: "profile")! + "," + UserDefaults.standard.string(forKey: "profile_bg")!
                        ]){error in
                            if let error = error{
                                print(error)
                                completion("error")
                                return
                            }
                            
                            else{
                                let currentTime = Date()
                                let chatRef = SOZIPRef.collection("Chat").document()
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yy/MM/dd HH:mm:ss.SSSS"
                                
                                let chatData : [String : Any] = [
                                    "msg" : AES256Util.encrypt(string: self.nickName + "님이 참여했어요!!"),
                                    "msg_type" : "participate",
                                    "sender" : Auth.auth().currentUser?.uid as! String,
                                    "date" : dateFormatter.string(from: currentTime),
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
                        SOZIPRef.updateData(["participants.\(Auth.auth().currentUser?.uid as! String)" : FieldValue.delete(),
                                             "payMethod.\(Auth.auth().currentUser?.uid as! String)" : FieldValue.delete(),
                                             "transactionMethod.\(Auth.auth().currentUser?.uid as! String)" : FieldValue.delete(),
                                             "profiles.\(Auth.auth().currentUser?.uid as! String)" : FieldValue.delete()]){error in
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
    
    func stopSOZIP(docId : String, completion : @escaping(_ result : String?) -> Void){
        let SOZIPRef = db.collection("SOZIP").document(docId)
        
        SOZIPRef.updateData(["status" : "end"]){error in
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
