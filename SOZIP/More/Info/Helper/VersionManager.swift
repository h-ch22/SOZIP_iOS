//
//  VersionManager.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/30.
//

import Foundation
import Firebase

class VersionManager : ObservableObject{
    let db = Firestore.firestore()

    func getVersion(_ completion: @escaping (_ data : [String : Any]?) -> Void){
        let versionRef = db.collection("Version").document("iOS")
        
        versionRef.getDocument(){(document, error) in
            guard let document = document, document.exists else{
                completion(nil)
                return
            }
            
            completion(document.data())
        }
    }
}
