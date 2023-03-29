//
//  NoticeHelper.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/27.
//

import Foundation
import Firebase
import FirebaseStorage

class NoticeHelper : ObservableObject{
    let db = Firestore.firestore()
    @Published var notice : [NoticeDataModel] = []
    @Published var imageURL : [String?] = []
    
    func getNotice(completion : @escaping(_ result : String?) -> Void){
        let noticeRef = db.collection("Notice").order(by: "timeStamp", descending: true)
        
        noticeRef.addSnapshotListener{querySnapshot, error in
            if let error = error{
                print(error)
                completion("error")
            }
            
            else{
                querySnapshot?.documentChanges.forEach{diff in
                    if diff.type == .added || diff.type == .modified{
                        let noticeTitle = diff.document.get("title") as? String ?? ""
                        
                        let docId = diff.document.documentID
                        let contents = diff.document.get("contents") as? String ?? ""
                        let timeStamp = diff.document.get("timeStamp") as? String ?? ""
                        let imageId = diff.document.get("imageId") as! String?
                        let imageIndex = diff.document.get("imageIndex") as! Int?
                        let url = diff.document.get("url") as! String?
                        
                        if diff.type == .added{
                            if !self.notice.contains(where : {$0.docId == docId}){
                                self.notice.append(NoticeDataModel(docId: docId, noticeTitle: noticeTitle, contents: contents, timeStamp: timeStamp, imageId: imageId, imageIndex: imageIndex, url: url))
                            }
                        }
                        
                        else if diff.type == .modified{
                            let index = self.notice.firstIndex(where: {$0.docId == docId})
                            
                            if index != nil{
                                self.notice[index!] = NoticeDataModel(docId: docId, noticeTitle: noticeTitle, contents: contents, timeStamp: timeStamp, imageId: imageId, imageIndex: imageIndex, url: url)
                            }
                        }
                    }
                    
                    else if diff.type == .removed{
                        let index = self.notice.firstIndex(where: {$0.docId == diff.document.documentID})
                        
                        if index != nil{
                            self.notice.remove(at: index!)
                        }
                    }
                }
            }
        }
    }
    
    func getImageURL(imageId : String?, imageIndex : Int?){
        if !self.imageURL.isEmpty{
            self.imageURL.removeAll()
        }
        
        if imageId != nil{
            let storageRef = Storage.storage()
            let noticeRef = storageRef.reference()
            
            for i in 0..<imageIndex!{
                let noticeDict = noticeRef.child("Notice/\(imageId!)/\(i).png")
                
                noticeDict.downloadURL(){downloadURL, error in
                    if let error = error{
                        print(error)
                    }
                    
                    else{
                        if !self.imageURL.contains(downloadURL?.absoluteString){
                            self.imageURL.append(downloadURL?.absoluteString)
                        }
                    }
                }
            }
            
            
        }
    }
}
