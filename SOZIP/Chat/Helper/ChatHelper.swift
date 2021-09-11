//
//  ChatHelper.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/23.
//

import Foundation
import Firebase
import SwiftUI

class ChatHelper : ObservableObject{
    @Published var ChatList : [ChatListDataModel] = []
    @Published var chatContents : [ChatDataModel] = []
    
    private let db = Firestore.firestore()
    
    func getChatList(completion : @escaping(_ result : Bool?) -> Void){
        let SOZIPRef = db.collection("SOZIP").order(by: "last_msg_time", descending: true)
        
        SOZIPRef.addSnapshotListener{querySnapshot, error in
            if let error = error{
                print(error)
            }
            
            else{
                querySnapshot?.documentChanges.forEach{diff in
                    if diff.type == .added || diff.type == .modified{
                        let participants = diff.document.get("participants") as? [String : String] ?? [:]
                        if participants.keys.contains(Auth.auth().currentUser?.uid ?? ""){
                            let docId = diff.document.documentID
                            let SOZIPName = diff.document.get("name") as? String ?? ""
                            let currentPeople = diff.document.get("currentPeople") as? Int ?? 1
                            
                            let last_msg = diff.document.get("last_msg") as? String ?? ""
                            let status = diff.document.get("status") as? String ?? ""
                            let color = diff.document.get("color") as? String ?? "bg_1"
                            let last_msg_time = diff.document.get("last_msg_time") as? String ?? ""
                            let profiles = diff.document.get("profiles") as? [String : String] ?? [:]
                            let Manager = diff.document.get("Manager") as? String ?? ""
                            
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
                            
                            if diff.type == .added{
                                if !self.ChatList.contains(where : {($0.docId == docId)}){
                                    self.ChatList.append(
                                        ChatListDataModel(docId: docId,
                                                          SOZIPName: AES256Util.decrypt(encoded: SOZIPName),
                                                          currentPeople: currentPeople,
                                                          last_msg: AES256Util.decrypt(encoded: last_msg),
                                                          participants: participants,
                                                          status: status,
                                                          profiles: profiles,
                                                          color: colorCode,
                                                          last_msg_time: last_msg_time,
                                                          Manager : Manager)
                                    )
                                }
                            }
                            
                            else if diff.type == .modified{
                                if self.ChatList.contains(where : {$0.docId == docId}){
                                    let index = self.ChatList.firstIndex(where : {$0.docId == docId})
                                    
                                    if index != nil{
                                        self.ChatList[index!] = ChatListDataModel(docId: docId,
                                                                                  SOZIPName: AES256Util.decrypt(encoded: SOZIPName),
                                                                                  currentPeople: currentPeople,
                                                                                  last_msg: AES256Util.decrypt(encoded: last_msg),
                                                                                  participants: participants,
                                                                                  status: status,
                                                                                  profiles: profiles,
                                                                                  color: colorCode,
                                                                                  last_msg_time: last_msg_time,
                                                                                  Manager: Manager)
                                    }
                                }
                            }
                        }
                        
                        else{
                            print("no document changes")
                        }
                    }
                    
                    else{
                        if let index = self.ChatList.firstIndex(where : {$0.docId == diff.document.documentID}) {
                            self.ChatList.remove(at: index)
                        }
                    }
                }
            }
        }
    }
    
    func getChatContents(data : ChatListDataModel, completion : @escaping(_ result : String?) -> Void){
        let chatRef = db.collection("SOZIP").document(data.docId).collection("Chat")
        
        chatRef.order(by: "date", descending: false).addSnapshotListener{(querySnapshot, error) in
            if let error = error{
                print(error)
                completion("error")
                
                return
            }
            
            else{
                querySnapshot?.documentChanges.forEach{ diff in
                    if diff.type == .added || diff.type == .modified{
                        let date = diff.document.get("date") as? String ?? ""
                        let msg = diff.document.get("msg") as? String ?? ""
                        let msg_type = diff.document.get("msg_type") as? String ?? ""
                        let sender = diff.document.get("sender") as? String ?? ""
                        let unread = diff.document.get("unread") as? [String] ?? []
                        let rootDocId = data.docId
                        let docId = diff.document.documentID
                        let imageIndex = diff.document.get("imageIndex") as? Int? ?? nil
                        let profile_all = data.profiles[sender] as? String ?? "chick,bg_3"
                        let profile_split = profile_all.components(separatedBy: ",")
                        var profile = ""
                        var profile_BG : Color = .sozip_bg_1
                        let url = diff.document.get("url") as? [String] ?? []
                        let account = diff.document.get("account") as? String ?? nil
                        
                        switch profile_split[0]{
                        case "pig" :
                            profile = "🐷"
                            
                        case "rabbit":
                            profile = "🐰"

                        case "tiger" :
                            profile = "🐯"

                        case "monkey" :
                            profile = "🐵"

                        case "chick" :
                            profile = "🐥"

                        default :
                            profile = "🐥"
                        }
                        
                        switch profile_split[1]{
                        case "bg_1":
                            profile_BG = .sozip_bg_1
                            
                        case "bg_2":
                            profile_BG = .sozip_bg_2

                        case "bg_3":
                            profile_BG = .sozip_bg_3

                        case "bg_4":
                            profile_BG = .sozip_bg_4

                        case "bg_5":
                            profile_BG = .sozip_bg_5

                        default:
                            profile_BG = .sozip_bg_1
                        }
                        
                        if !self.chatContents.contains(where : {$0.docId == docId}){
                            self.chatContents.append(
                                ChatDataModel(rootDocId: rootDocId,
                                              docId: docId,
                                              msg: msg,
                                              sender: sender,
                                              unread: unread.count,
                                              time: date,
                                              type: msg_type,
                                              imageIndex: imageIndex,
                                              profile: profile,
                                              profile_BG: profile_BG,
                                              nickName: data.participants[sender] ?? "",
                                              url : url,
                                              account : account)
                            )
                        }
                        
                        else{
                            let index = self.chatContents.firstIndex(where : {$0.docId == docId})
                            
                            if index != nil{
                                self.chatContents[index!] = ChatDataModel(rootDocId: rootDocId,
                                                                        docId: docId,
                                                                        msg: msg,
                                                                        sender: sender,
                                                                        unread: unread.count,
                                                                        time: date,
                                                                        type: msg_type,
                                                                        imageIndex: imageIndex,
                                                                        profile: profile,
                                                                        profile_BG: profile_BG,
                                                                        nickName: data.participants[sender] ?? "",
                                                                        url : url,
                                                                        account: account)
                            }
                            
                            
                        }
                    }
                }
                
                completion("success")
            }
        }
    }
    
    func sendPlainText(rootDocId : String, msg : String, completion : @escaping(_ result : String?) -> Void){
        let chatRef = db.collection("SOZIP").document(rootDocId).collection("Chat")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy/MM/dd kk:mm:ss.SSSS"
        
        chatRef.document().setData([
            "date" : dateFormatter.string(from: Date()),
            "msg" : AES256Util.encrypt(string: msg),
            "msg_type" : "text",
            "sender" : Auth.auth().currentUser?.uid as? String ?? "",
            "unread" : []
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
    
    func sendAccount(rootDocId : String, account : String?, completion : @escaping(_ result : String?) -> Void){
        let chatRef = db.collection("SOZIP").document(rootDocId).collection("Chat")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy/MM/dd HH:mm:ss.SSSS"
        
        chatRef.document().setData([
            "date" : dateFormatter.string(from: Date()),
            "msg" : AES256Util.encrypt(string: "결제 금액을 송금해주세요!"),
            "msg_type" : "account",
            "sender" : Auth.auth().currentUser?.uid ?? "",
            "unread" : [],
            "account" : account
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
    
    func sendSingleImage(rootDocId : String, image : Data?, completion : @escaping(_ result : String?) -> Void){
        var chatRef : DocumentReference? = nil
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy/MM/dd HH:mm:ss.SSSS"
        
        chatRef = db.collection("SOZIP").document(rootDocId).collection("Chat").addDocument(data : [
            "date" : dateFormatter.string(from: Date()),
            "msg" : AES256Util.encrypt(string: "이미지를 보냈습니다."),
            "msg_type" : "image",
            "sender" : Auth.auth().currentUser?.uid as? String ?? "",
            "unread" : [],
        ]){error in
            if let error = error{
                print(error)
                
                completion("error")
            }
            
            else{
                let storage = Storage.storage()
                let storageRef = storage.reference()
                let chatImgRef = storageRef.child("Chat/\(chatRef!.documentID)/0.png")
                                
                if image != nil{
                    let uploadTask = chatImgRef.putData(image!, metadata: nil){(metadata, error) in
                        guard let metadata = metadata else{return}
                        
                        chatImgRef.downloadURL{(url, error) in
                            guard let downloadURL = url else{return}
                            
                            self.db.collection("SOZIP").document(rootDocId).collection("Chat").document(chatRef!.documentID).updateData([
                                "url" : [downloadURL.absoluteString],
                                "imageIndex" : 1
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
                    }
                }
            }
        }
    }
    
    func sendMultipleImages(image : [ChatPhotoPickerModel], rootDocId : String, completion : @escaping(_ result : String?) -> Void){
        var chatRef : DocumentReference? = nil
        var imgURL : [String] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy/MM/dd HH:mm:ss.SSSS"
        
        chatRef = db.collection("SOZIP").document(rootDocId).collection("Chat").addDocument(data : [
            "date" : dateFormatter.string(from: Date()),
            "msg" : AES256Util.encrypt(string: "\(image.count)장의 이미지를 보냈습니다."),
            "msg_type" : "image",
            "sender" : Auth.auth().currentUser?.uid as? String ?? "",
            "unread" : [],
        ]){error in
            if let error = error{
                print(error)
                
                completion("error")
            }
            
            else{
                let storage = Storage.storage()
                let storageRef = storage.reference()
                
                for i in 0..<image.count{
                    let chatImgRef = storageRef.child("Chat/\(chatRef!.documentID)/\(String(i)).png")

                    let uploadtask = chatImgRef.putFile(from : image[i].url!, metadata : nil){metadata, error in
                        guard let metadata = metadata else{return}
                        
                        chatImgRef.downloadURL{(url, error) in
                            guard let downloadURL = url else{return}
                            imgURL.append(downloadURL.absoluteString)
                        }
                    }
                }
                
                self.db.collection("SOZIP").document(rootDocId).collection("Chat").document(chatRef!.documentID).updateData([
                    "url" : imgURL,
                    "imageIndex" : image.count
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
        }
    }
}
