//
//  UserManagement.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/28.
//

import Foundation
import Firebase
import SwiftUI
import UIKit

class UserManagement : ObservableObject{
    private let db = Firestore.firestore()
    private let storageRef = Storage.storage().reference()
    @Published var name = AES256Util.decrypt(encoded:UserDefaults.standard.string(forKey: "name")  ?? "")
    @Published var nickName = AES256Util.decrypt(encoded:UserDefaults.standard.string(forKey: "nickName") ?? "")
    @Published var school = AES256Util.decrypt(encoded:UserDefaults.standard.string(forKey: "school") ?? "")
    @Published var bounds = AES256Util.decrypt(encoded:UserDefaults.standard.string(forKey: "bounds") ?? "")
    
    func signUp(mail : String, password : String, name : String, nickName : String, school : String, studentNo : String, phone : String, idCard : Image, marketingAccept : Bool,
                completion: @escaping(_ result : String?) -> Void){
        Auth.auth().createUser(withEmail: mail, password: password){authResult, error in
            if let error = error{
                print(error.localizedDescription)
                completion(error.localizedDescription)
            }
            
            else{
                let userRef = self.db.collection("Users").document(Auth.auth().currentUser?.uid ?? "")
                let uiImage = idCard.asUIImage()
                
                guard let data = uiImage.jpegData(compressionQuality: 0.5) else {return}
                
                userRef.setData([
                    "mail" : AES256Util.encrypt(string: mail),
                    "name" : AES256Util.encrypt(string: name),
                    "nickName" : AES256Util.encrypt(string: nickName),
                    "phone" : AES256Util.encrypt(string: phone),
                    "school" : AES256Util.encrypt(string: school),
                    "studentNo" : AES256Util.encrypt(string: studentNo),
                    "token" : Messaging.messaging().fcmToken ?? "",
                    "marketingAccept" : marketingAccept
                ]){error in
                    if let error = error{
                        print(error)
                        completion(error.localizedDescription)
                    }
                    
                    else{
                        let idCardRef = self.storageRef.child("idCard/\(school)/\(Auth.auth().currentUser?.uid ?? "")/idCard.png")
                        
                        idCardRef.putData(data, metadata: nil){(metadata, error) in
                            guard let metadata = metadata else{
                                completion("no metadata")
                                return
                            }
                            
                            UserDefaults.standard.set(mail, forKey: "signIn_mail")
                            UserDefaults.standard.set(password, forKey: "signIn_password")
                            UserDefaults.standard.set(AES256Util.encrypt(string: name), forKey: "name")
                            UserDefaults.standard.set(AES256Util.encrypt(string: school), forKey: "school")
                            UserDefaults.standard.set(AES256Util.encrypt(string: nickName), forKey: "nickName")
                            UserDefaults.standard.set(marketingAccept, forKey : "recceiveMarketing")
                            
                            completion("success")
                        }
                    }
                }
            }
        }
    }
    
    func signIn(mail : String, password : String, completion: @escaping(_ result : String?) -> Void){
        Auth.auth().signIn(withEmail: mail, password: password){(authResult, error) in
            if let error = error{
                print(error)
                completion(error.localizedDescription)
            }
            
            else{
                if Auth.auth().currentUser != nil{
                    let docRef = self.db.collection("Users").document(Auth.auth().currentUser?.uid ?? "")
                    
                    docRef.getDocument(){(document, error) in
                        if let error = error{
                            completion(error.localizedDescription)
                            print(error)
                        }
                        
                        else{
                            if document != nil{
                                let name = document!.get("name") as? String ?? ""
                                let school = document!.get("school") as? String ?? ""
                                let nickName = document!.get("nickName") as? String ?? ""
                                let bounds = document!.get("bounds") as? Int ?? 0
                                let receiveMarketing = document!.get("acceptMarketing") as? Bool ?? false
                                
                                UserDefaults.standard.set(name, forKey: "name")
                                UserDefaults.standard.set(school, forKey: "school")
                                UserDefaults.standard.set(nickName, forKey: "nickName")
                                UserDefaults.standard.set(bounds, forKey: "bounds")
                                UserDefaults.standard.set(receiveMarketing, forKey : "recceiveMarketing")
                                
                                self.updateToken()
                                
                                completion("success")
                            }
                            
                            else{
                                completion(error?.localizedDescription)
                            }
                        }
                    }
                }
                
                else{
                    completion("error while processing signIn")
                }
            }
        }
    }
    
    func getUserData(){
        
    }
    
    func signOut(completion: @escaping(_ result : Bool?) -> Void){
        do {
            UserDefaults.standard.removeObject(forKey: "signIn_mail")
            UserDefaults.standard.removeObject(forKey: "signIn_password")

            try Auth.auth().signOut()
            completion(true)
        }
        
        catch {
            print("already logged out")
            completion(false)
        }
    }
    
    func updateToken(){
        if Auth.auth().currentUser?.uid != nil{
            let userRef = db.collection("Users").document(Auth.auth().currentUser?.uid as! String)
            
            userRef.updateData([
                "token" : Messaging.messaging().fcmToken ?? ""
            ])
        }
    }
    
    func secession(completion : @escaping(_ result : String?) -> Void){
        UserDefaults.standard.removeObject(forKey: "signIn_mail")
        UserDefaults.standard.removeObject(forKey: "signIn_password")
        
        let user = Auth.auth().currentUser
        let uid = user?.uid as? String ?? ""
        
        if user != nil{
            db.collection("Users").document(uid).delete(){error in
                if let error = error{
                    completion("error")
                    print(error)
                    
                    return
                }
                
                else{
                    user?.delete{error in
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
            }
            
        }
        
        else{
            completion("noUser")
        }
    }
}
