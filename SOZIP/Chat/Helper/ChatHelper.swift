//
//  ChatHelper.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/04.
//

import Foundation
import Firebase
import SwiftUI
import Photos

class ChatHelper : ObservableObject{
    private let db = Firestore.firestore()
    private let uid = Auth.auth().currentUser?.uid ?? ""
    @Published var chatList : [ChatDataModel] = []
    @Published var chatPreviewList : [ChatPreviewDataModel] = []
    let storage = Storage.storage()
    
    func downloadMultipleImage(url : [String?], docRef : String){
        let storageRef = self.storage.reference()
        
        for i in 0..<url.count{
            let imgRef = storageRef.child("Chat/\(docRef)/\(String(i)).png")
            
            imgRef.getData(maxSize : 100*1024*1024){data, error in
                if let error = error{
                    
                }
                
                else{
                    let uiImage = UIImage(data : data!)
                    let album = "SOZIP"
                    
                    UIImageWriteToSavedPhotosAlbum(uiImage!, nil, nil, nil)
                }
            }
        }
    }
    
    func downloadSingleImage(url : URL?, docRef : String, index : Int){
        let storageRef = self.storage.reference()
        let imgRef = storageRef.child("Chat/\(docRef)/\(String(index)).png")
        
        imgRef.getData(maxSize : 100*1024*1024){data, error in
            if let error = error{
                
            }
            
            else{
                let uiImage = UIImage(data : data!)
                let album = "SOZIP"
                
                UIImageWriteToSavedPhotosAlbum(uiImage!, nil, nil, nil)
            }
        }
    }
    
    func sendChat(rootDocId : String, msg : String, completion : @escaping(_ result : String?) -> Void){
        let chatRef = db.collection("SOZIP").document(rootDocId).collection("Chat").document()
        
        let date = Date()
        let msg = AES256Util.encrypt(string: msg)
        let msg_type = "text"
        let sender = Auth.auth().currentUser?.uid as! String
        let unread : [String] = []
        
        let data : [String : Any] = [
            "date" : date,
            "msg" : msg,
            "msg_type" : msg_type,
            "sender" : sender,
            "unread" : unread
        ]
        
        chatRef.setData(data){error in
            if let error = error{
                print(error)
            }
        }
    }
    
    func sendCapturedImage(rootDocId : String, image : Image){
        let uiImage = image.asUIImage()
        
        guard let data = uiImage.jpegData(compressionQuality: 0.5) else {return}
        
        let chatRef = db.collection("SOZIP").document(rootDocId).collection("Chat").document()
        let date = Date()
        let msg = AES256Util.encrypt(string: "이미지를 보냈습니다.")
        let msg_type = "image"
        let sender = Auth.auth().currentUser?.uid as! String
        let unread : [String] = []
        var docId = chatRef.documentID
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imgRef = storageRef.child("Chat/\(docId)/0.png")
        
        imgRef.putData(data, metadata: nil){(metadata, error) in
            guard let metadata = metadata else{return}
            
            imgRef.downloadURL{(url, error) in
                guard let downloadURL = url else{return}
                
                let urlList : [String] = [downloadURL.absoluteString]
                
                let data : [String : Any] = [
                    "date" : date,
                    "msg" : msg,
                    "msg_type" : msg_type,
                    "sender" : sender,
                    "unread" : unread,
                    "imageIndex" : 1,
                    "url" : urlList
                ]
                
                chatRef.setData(data){error in
                    if let error = error{
                        print(error)
                    }
                    
                    
                }
            }
        }
    }
    
    func sendImage(rootDocId : String, mediaItems : ChatPickedMediaItems, completion : @escaping(_ result : String?) -> Void){
        let chatRef = db.collection("SOZIP").document(rootDocId).collection("Chat").document()
        let date = Date()
        let msg = AES256Util.encrypt(string: "이미지를 보냈습니다.")
        let msg_type = "image"
        let sender = Auth.auth().currentUser?.uid as! String
        let unread : [String] = []
        var docId = chatRef.documentID
        
        if !mediaItems.items.isEmpty{
            var urlList : [String] = []
            
            for i in 0..<mediaItems.items.count{
                let storage = Storage.storage()
                let storageRef = storage.reference()
                let imgRef = storageRef.child("Chat/\(docId)/\(String(i)).png")
                
                
                let uploadTask = imgRef.putFile(from : mediaItems.items[i].url!, metadata: nil){metadata, error in
                    guard let metadata = metadata else{return}
                    
                    imgRef.downloadURL{(url, error) in
                        guard let downloadURL = url else{
                            completion("error")
                            return
                        }
                        
                        urlList.append(downloadURL.absoluteString)
                        
                        if i == mediaItems.items.count - 1{
                            let data : [String : Any] = [
                                "date" : date,
                                "msg" : msg,
                                "msg_type" : msg_type,
                                "sender" : sender,
                                "unread" : unread,
                                "imageIndex" : mediaItems.items.count,
                                "url" : urlList
                            ]
                            
                            chatRef.setData(data){error in
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
    
    func getChatList(completion : @escaping(_ result : String?) -> Void){
        let chatListRef = db.collection("SOZIP")
        
        chatListRef.addSnapshotListener{(querySnapshot, error) in
            if let error = error{
                print(error)
                completion("error")

                return
            }

            else{
                if self.uid == ""{
                    completion("noUser")

                    return
                }

                else{
                    querySnapshot?.documentChanges.forEach{ diff in
                        if diff.type == .added || diff.type == .modified{
                            let participants = diff.document["participants"] as? [String : String] ?? [:]
                            let status = diff.document["status"] as? String ?? ""

                            if participants.keys.contains(self.uid){
                                let docId = diff.document.documentID
                                let status = diff.document["status"] as? String ?? ""
                                let currentPeople = diff.document["currentPeople"] as? Int ?? 1
                                let name = AES256Util.decrypt(encoded: diff.document["name"] as? String ?? "")
                                let last_msg = AES256Util.decrypt(encoded: diff.document["last_msg"] as? String ?? "")
                                let last_msg_type = diff.document["last_msg_type"] as! String
                                let last_msg_time = diff.document["last_msg_time"] as! Timestamp

                                let date = last_msg_time.dateValue()
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yy/MM/dd HH:mm"

                                if diff.type == .added{
                                    if !self.chatPreviewList.contains(where : {($0.docId == docId)}){
                                        self.chatPreviewList.append(
                                            ChatPreviewDataModel(docId: docId, currentPeople: currentPeople, status: status, name: name, last_msg: last_msg, last_msg_type: last_msg_type, last_msg_time: formatter.string(from: date))
                                        )
                                    }
                                }

                                else{
                                    let index = self.chatPreviewList.firstIndex(where : {$0.docId == docId})

                                    if index != nil{
                                        self.chatPreviewList[index!].docId = docId
                                        self.chatPreviewList[index!].currentPeople = currentPeople
                                        self.chatPreviewList[index!].status = status
                                        self.chatPreviewList[index!].name = name
                                        self.chatPreviewList[index!].last_msg = last_msg
                                        self.chatPreviewList[index!].last_msg_type = last_msg_type
                                        self.chatPreviewList[index!].last_msg_time = formatter.string(from: date)
                                    }
                                }
                            }
                        }

                        else{
                            let participants = diff.document["participants"] as? [String : String] ?? [:]
                            let status = diff.document["status"] as? String ?? ""

                            if participants.keys.contains(self.uid){
                                var docId = diff.document.documentID
                                let index = self.chatPreviewList.firstIndex(where: {$0.docId == docId})

                                if index != nil{
                                    self.chatPreviewList.remove(at: index!)
                                }
                            }



                        }
                    }

                    self.chatPreviewList.sort{
                        $0.last_msg_time > $1.last_msg_time
                    }
                }
            }

        }
        
//        chatListRef.getDocuments(){(querySnapshot, error) in
//            if let error = error{
//                print(error)
//                
//                completion("error")
//            }
//            
//            else{
//                for document in querySnapshot!.documents{
//                    let participants = document["participants"] as? [String : String] ?? [:]
//                    let status = document["status"] as? String ?? ""
//                    
//                    if participants.keys.contains(self.uid) && status != "closed"{
//                        let docId = document.documentID
//                        let status = document["status"] as? String ?? ""
//                        let currentPeople = document["currentPeople"] as? Int ?? 1
//                        let name = AES256Util.decrypt(encoded: document["name"] as? String ?? "")
//                        let colorName = document["Color"] as? String ?? "bg_1"
//                        let last_msg = AES256Util.decrypt(encoded: document["last_msg"] as? String ?? "")
//                        let last_msg_type = document["last_msg_type"] as! String
//                        let last_msg_time = document["last_msg_time"] as! Timestamp
//                        
//                        var color : Color = .sozip_bg_1
//                        
//                        switch(colorName){
//                        case "bg_1":
//                            color = .sozip_bg_1
//                            
//                        case "bg_2":
//                            color = .sozip_bg_2
//                            
//                        case "bg_3":
//                            color = .sozip_bg_3
//                            
//                        case "bg_4":
//                            color = .sozip_bg_4
//                            
//                        case "bg_5":
//                            color = .sozip_bg_5
//                            
//                        default:
//                            color = .sozip_bg_1
//                        }
//                        
//                        let date = last_msg_time.dateValue()
//                        let formatter = DateFormatter()
//                        formatter.dateFormat = "yy/MM/dd HH:mm"
//                        
//                        if !self.chatPreviewList.contains(where : {($0.docId == docId)}){
//                            self.chatPreviewList.append(
//                                ChatPreviewDataModel(docId: docId, currentPeople: currentPeople, status: status, name: name, color: color, last_msg: last_msg, last_msg_type: last_msg_type, last_msg_time: formatter.string(from: date))
//                            )
//                        }
//                    }
//                    
//                    
//                }
//                
//                self.chatPreviewList.sort{
//                    $0.last_msg_time > $1.last_msg_time
//                }
//            }
//        }
    }
    
    func getChatContents(rootDocId : String, completion : @escaping(_ result : String?) -> Void){
        let docRef = db.collection("SOZIP").document(rootDocId)
        
        docRef.getDocument(){(document, error) in
            if let error = error{
                print(error)
                completion("error")
                
                return
            }
            
            else{
                if document != nil{
                    let participants = document!.get("participants") as? [String : String] ?? [:]
                    
                    let chatRef = docRef.collection("Chat")
                    
                    self.db.collection("SOZIP").addSnapshotListener{(querySnapshot, error) in
                        if let error = error{
                            print(error)
                        }
                        
                        else{
                            querySnapshot?.documentChanges.forEach{diff in
                                if diff.type == .modified{
                                    if diff.document.documentID == rootDocId{
                                        let participants = diff.document["participants"] as? [String : String] ?? [:]
                                        
                                        let index = self.chatList.firstIndex(where : {$0.rootDocId == rootDocId})
                                        
                                        if index != nil{
                                            
                                            self.chatList[index!].participants = participants
                                            
                                        }
                                    }
                                }
                            }
                            
                        }
                        
                    }
                    
//                    chatRef.getDocuments(){(querySnapshot, error) in
//                        if let error = error{
//                            print(error)
//                            completion("error")
//                            return
//                        }
//
//                        else{
//                            for document in querySnapshot!.documents{
//                                let rootDocId = rootDocId
//                                let docId = document.documentID
//                                let timeStamp = document["date"] as! Timestamp
//                                let msg = AES256Util.decrypt(encoded: document["msg"] as! String)
//                                let msg_type = document["msg_type"] as! String
//                                let sender = document["sender"] as! String
//                                let unread = document["unread"] as! [String]
//                                let index = document["imageIndex"] as? Int
//                                let urlList = document["url"] as? [String] ?? [""]
//
//                                let date = timeStamp.dateValue()
//                                let formatter = DateFormatter()
//                                formatter.dateFormat = "yy/MM/dd HH:mm"
//
//                                let storageRef = self.storage.reference()
//
//                                if !self.chatList.contains(where : {($0.docId == docId)}){
//                                    self.chatList.append(
//                                        ChatDataModel(rootDocId: rootDocId, docId: docId, time: formatter.string(from: date), sender: sender, unread: unread, type: msg_type, msg: msg, participants: participants, items : urlList, index : index)
//                                    )
//                                }
//
//                            }
//
//                            self.chatList.sort{
//                                $0.time < $1.time
//                            }
//                        }
//                    }
                    
                    chatRef.addSnapshotListener{(querySnapshot, error) in
                        if let error = error{
                            print(error)
                            completion("error")

                            return
                        }

                        else{
                            if self.uid == ""{
                                completion("noUser")

                                return
                            }

                            else{
                                querySnapshot?.documentChanges.forEach{ diff in
                                    if diff.type == .added || diff.type == .modified{
                                        let rootDocId = rootDocId
                                        let docId = diff.document.documentID
                                        let timeStamp = diff.document["date"] as! Timestamp
                                        let msg = AES256Util.decrypt(encoded: diff.document["msg"] as! String)
                                        let msg_type = diff.document["msg_type"] as! String
                                        let sender = diff.document["sender"] as! String
                                        let unread = diff.document["unread"] as! [String]
                                        let index = diff.document["imageIndex"] as? Int
                                        let urlList = diff.document["url"] as? [String] ?? [""]

                                        let date = timeStamp.dateValue()
                                        let formatter = DateFormatter()
                                        formatter.dateFormat = "yy/MM/dd HH:mm"

                                        if diff.type == .added{
                                            if !self.chatList.contains(where : {($0.docId == docId)}){
                                                self.chatList.append(
                                                    ChatDataModel(rootDocId: rootDocId, docId: docId, time: formatter.string(from: date), sender: sender, unread: unread, type: msg_type, msg: msg, participants: participants, items : urlList, index : index)
                                                )
                                            }
                                        }

                                        else{
                                            let index = self.chatList.firstIndex(where : {$0.docId == docId})

                                            if index != nil{
                                                self.chatList[index!].docId = docId
                                                self.chatList[index!].time = formatter.string(from: date)
                                                self.chatList[index!].sender = sender
                                                self.chatList[index!].unread = unread
                                                self.chatList[index!].type = msg_type
                                                self.chatList[index!].msg = msg

                                            }
                                        }

                                    }

                                    else{
                                        var docId = diff.document.documentID
                                        let index = self.chatList.firstIndex(where: {$0.docId == docId})

                                        if index != nil{
                                            self.chatList.remove(at: index!)
                                        }
                                    }
                                }

                                self.chatList.sort{
                                    $0.time < $1.time
                                }
                            }
                        }

                    }
                    
//                    chatRef.addSnapshotListener{(snap, err) in
//                        if err != nil{
//                            print(err)
//
//                            return
//                        }
//
//                        guard let data = snap else{return}
//
//                        data.documentChanges.forEach{(doc) in
//                            if doc.type == .added{
//
//                            }
//                        }
//                    }
                    
                }
            }
        }
        
        
        
    }
}
