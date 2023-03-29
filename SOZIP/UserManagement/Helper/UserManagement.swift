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
import FirebaseStorage

class UserManagement : ObservableObject{
    private let db = Firestore.firestore()
    private let storageRef = Storage.storage().reference()
    
    @Published var name = AES256Util.decrypt(encoded:UserDefaults.standard.string(forKey: "name")  ?? "")
    @Published var nickName = AES256Util.decrypt(encoded:UserDefaults.standard.string(forKey: "nickName") ?? "")
//    @Published var school = AES256Util.decrypt(encoded:UserDefaults.standard.string(forKey: "school") ?? "")
    @Published var bounds = AES256Util.decrypt(encoded:UserDefaults.standard.string(forKey: "bounds") ?? "")
    @Published var marketingAccept = UserDefaults.standard.bool(forKey: "receiveMarketing")
    @Published var profile = UserDefaults.standard.string(forKey : "profile")
    @Published var profile_bg = UserDefaults.standard.string(forKey : "profile_bg")
    @Published var accounts : [accountDataModel] = []
    
    func signUp(mail : String, password : String, name : String, nickName : String, phone : String, marketingAccept : Bool,
                completion: @escaping(_ result : String?) -> Void){
        Auth.auth().createUser(withEmail: mail, password: password){authResult, error in
            if let error = error{
                print(error.localizedDescription)
                completion(error.localizedDescription)
            }
            
            else{
                let userRef = self.db.collection("Users").document(Auth.auth().currentUser?.uid ?? "")
//                let uiImage = idCard.asUIImage()
                
//                guard let data = uiImage.jpegData(compressionQuality: 0.5) else {return}
                
                userRef.setData([
                    "mail" : AES256Util.encrypt(string: mail),
                    "name" : AES256Util.encrypt(string: name),
                    "nickName" : AES256Util.encrypt(string: nickName),
                    "phone" : AES256Util.encrypt(string: phone),
//                    "school" : AES256Util.encrypt(string: school),
//                    "studentNo" : AES256Util.encrypt(string: studentNo),
                    "token" : Messaging.messaging().fcmToken ?? "",
                    "marketingAccept" : marketingAccept,
                    "profile" : "chick",
                    "profile_bg" : "bg_3"
                ]){error in
                    if let error = error{
                        print(error)
                        completion(error.localizedDescription)
                    }
                    
                    else{
                        UserDefaults.standard.set(mail, forKey: "signIn_mail")
                        UserDefaults.standard.set(password, forKey: "signIn_password")
                        UserDefaults.standard.set(AES256Util.encrypt(string: name), forKey: "name")
//                        UserDefaults.standard.set(AES256Util.encrypt(string: school), forKey: "school")
                        UserDefaults.standard.set(AES256Util.encrypt(string: nickName), forKey: "nickName")
                        UserDefaults.standard.set(marketingAccept, forKey : "receiveMarketing")
                        UserDefaults.standard.set("chick", forKey: "profile")
                        UserDefaults.standard.set("bg_1", forKey: "profile_bg")
                        
                        completion("success")
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
//                                let school = document!.get("school") as? String ?? ""
                                let nickName = document!.get("nickName") as? String ?? ""
                                let bounds = document!.get("bounds") as? Int ?? 0
                                let receiveMarketing = document!.get("acceptMarketing") as? Bool ?? false
                                let profile = document!.get("profile") as? String ?? ""
                                let profile_bg = document!.get("profile_bg") as? String ?? ""
                                
                                UserDefaults.standard.set(name, forKey: "name")
//                                UserDefaults.standard.set(school, forKey: "school")
                                UserDefaults.standard.set(nickName, forKey: "nickName")
                                UserDefaults.standard.set(bounds, forKey: "bounds")
                                UserDefaults.standard.set(receiveMarketing, forKey : "receiveMarketing")
                                UserDefaults.standard.set(profile, forKey: "profile")
                                UserDefaults.standard.set(profile_bg, forKey: "profile_bg")

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
    
    func updatePassword(password : String, completion : @escaping(_ result : String?) -> Void){
        if Auth.auth().currentUser == nil{
            completion("noUser")
            return
        }
        
        else{
            Auth.auth().currentUser?.updatePassword(to: password){error in
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
    
    func updateMarketingStatus(status : Bool){
        if Auth.auth().currentUser?.uid != nil{
            db.collection("Users").document(Auth.auth().currentUser?.uid as! String).updateData([
                "marketingAccept" : status
            ]){error in
                if let error = error{
                    print(error)
                }
                
                else{
                    UserDefaults.standard.setValue(status, forKey: "receiveMarketing")
                }
            }
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
    
    func getColor() -> Color{
        switch profile_bg{
        case "bg_1":
            return .sozip_bg_1
            
        case "bg_2":
            return .sozip_bg_2
            
        case "bg_3":
            return .sozip_bg_3
            
        case "bg_4":
            return .sozip_bg_4
            
        case "bg_5":
            return .sozip_bg_5
            
        default:
            return .sozip_bg_3
        }
    }
    
    func getProfile() -> String{
        switch profile{
        case "pig" :
            return "🐷"
            
        case "chick" :
            return "🐥"
            
        case "rabbit" :
            return "🐰"
            
        case "tiger" :
            return "🐯"
            
        case "monkey" :
            return "🐵"
            
        default :
            return "🐥"
        }
    }
    
    func setProfile(profile : String, profile_bg : Color, completion : @escaping(_ result : Bool?) -> Void){
        var profile_bg_string = ""
        
        switch profile_bg{
        case .sozip_bg_1:
            profile_bg_string = "bg_1"
            
        case .sozip_bg_2:
            profile_bg_string = "bg_2"
            
        case .sozip_bg_3:
            profile_bg_string = "bg_3"
            
        case .sozip_bg_4:
            profile_bg_string = "bg_4"
            
        case .sozip_bg_5:
            profile_bg_string = "bg_5"
            
        default:
            profile_bg_string = "bg_1"
        }
        
        let userRef = db.collection("Users").document(Auth.auth().currentUser?.uid as! String)
        
        let profileData : [String : Any] = [
            "profile" : profile,
            "profile_bg" : profile_bg_string
        ]
        
        userRef.updateData(profileData){error in
            if let error = error{
                print(error)
                completion(false)
            }
            
            else{
                UserDefaults.standard.setValue(profile, forKey: "profile")
                UserDefaults.standard.setValue(profile_bg_string, forKey: "profile_bg")
                
                completion(true)
            }
        }
    }
    
    func addAccount(bank : String, accountNumber : String, name : String, completion : @escaping(_ result : String?) -> Void){
        if Auth.auth().currentUser == nil{
            completion("noUser")
            return
        }
        
        let userRef = db.collection("Users").document(Auth.auth().currentUser?.uid as! String)
                
        userRef.updateData(["bankAccount" : FieldValue.arrayUnion(["\(AES256Util.encrypt(string: bank)) \(AES256Util.encrypt(string: accountNumber)) \(AES256Util.encrypt(string: name))"])]){error in
            if error != nil{
                print(error)
                completion("error")
            }
            
            else{
                self.getAccountInfo()
                
                completion("success")
            }
        }
    }
    
    func removeAccount(index : Int, completion : @escaping(_ result : String?) -> Void){
        if Auth.auth().currentUser == nil{
            completion("noUser")
            
            return
        }
        
        let userRef = db.collection("Users").document(Auth.auth().currentUser?.uid as! String)
        

    }
    
    func updateAccount(index : Int, name : String, accountNumber : String, completion : @escaping(_ result : String?) -> Void){
        
    }
    
    func getAccountInfo(){
        if Auth.auth().currentUser == nil{
            return
        }
        
        let userRef = db.collection("Users").document(Auth.auth().currentUser?.uid ?? "")

        userRef.getDocument(){(document, error) in
            var account_tmp : [String] = []
            
            if let error = error{
                print(error)
                return
            }
            
            else if document != nil{
                account_tmp = document?.get("bankAccount") as? [String] ?? []
                
                for i in 0..<account_tmp.count{
                    let accInfo = account_tmp[i].components(separatedBy: " ")
                    
                    let bank = accInfo[0]
                    let accountNumber = accInfo[1]
                    let name = accInfo[2]
                    
                    self.accounts.append(accountDataModel(bank: bank, accountNumber: accountNumber, name: name))
                }
            }
        }
        
        
    }
    
    func getPersonalInfo(completion : @escaping(_ result : String?) -> Void) -> PersonalInfoModel{
        if Auth.auth().currentUser == nil{
            completion("noUser")
            
            return PersonalInfoModel(name: "", phone: "", email: "", studentNo: "", school: "", nickName: "")
        }
        
        else{
            let userRef = db.collection("Users").document(Auth.auth().currentUser?.uid ?? "")
            var info : PersonalInfoModel? = nil
            
            userRef.getDocument(){document, error in
                if let error = error{
                    print(error)
                    completion("error")
                    
                    return
                }
                
                else{
                    if document != nil{
                        let name = AES256Util.decrypt(encoded: document?.get("name") as? String ?? "")
                        let nickName = AES256Util.decrypt(encoded: document?.get("nickName") as? String ?? "")
                        let phone = AES256Util.decrypt(encoded: document?.get("phone") as? String ?? "")
                        let email = Auth.auth().currentUser?.email ?? ""
                        let school = "jbnu"
                        let studentNo = AES256Util.decrypt(encoded: document?.get("studentNo") as? String ?? "")
                        
                        info = PersonalInfoModel(name: name, phone: phone, email: email, studentNo: studentNo, school: school, nickName: nickName)
                    }
                    
                }
            }
            
            return info ?? PersonalInfoModel(name: "", phone: "", email: "", studentNo: "", school: "", nickName: "")
        }
    }
    
    func updateProfile(nickName : String, bg : Color, profile : String, completion : @escaping(_ result : Bool?) -> Void){
        let userRef = db.collection("Users").document(Auth.auth().currentUser?.uid ?? "")
        let nickName_encrypted = AES256Util.encrypt(string: nickName)
        var profile_string = ""
        var bg_string = ""
        
        switch profile{
        case "🐷":
            profile_string = "pig"
            
        case "🐰":
            profile_string = "rabbit"
            
        case "🐯":
            profile_string = "tiger"
            
        case "🐵":
            profile_string = "monkey"
            
        case "🐥":
            profile_string = "chick"
            
        default :
            profile_string = "chick"
        }
        
        switch bg{
        case .sozip_bg_1:
            bg_string = "bg_1"
            
        case .sozip_bg_2:
            bg_string = "bg_2"
            
        case .sozip_bg_3:
            bg_string = "bg_3"
            
        case .sozip_bg_4:
            bg_string = "bg_4"
            
        case .sozip_bg_5:
            bg_string = "bg_5"
            
        default:
            bg_string = "bg_1"
        }
        
        let data : [String : Any] = [
            "nickName" : nickName_encrypted,
            "profile" : profile_string,
            "profile_bg" : bg_string
        ]
        
        userRef.updateData(data){error in
            if let error = error{
                print(error)
                completion(false)
            }
            
            else{
                UserDefaults.standard.setValue(profile_string, forKey: "profile")
                UserDefaults.standard.setValue(bg_string, forKey: "profile_bg")
                UserDefaults.standard.setValue(nickName_encrypted, forKey: "nickName")
                
                completion(true)
            }
        }
    }
    
    func getAdminInfo(completion : @escaping(_ result : String?) -> Void){
        let docRef = db.collection("Permissions").document(Auth.auth().currentUser?.uid ?? "")
        
        docRef.getDocument(){(document, error) in
            if let error = error{
                print(error)
                completion("error")
                
                return
            }
            
            else{
                let adminInfo = document?.get("Admin") as? Bool ?? nil
                
                if adminInfo != nil && adminInfo == true{
                    completion("true")
                }
                
                else{
                    completion("false")
                }
            }
        }
    }
}
