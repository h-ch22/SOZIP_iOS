//
//  LAHelper.swift
//  SOZIP
//
//  Created by Changjin Ha on 2023/04/09.
//

import Foundation
import LocalAuthentication

class LAHelper : ObservableObject{
    @Published var isAuthenticated = false
    
    func auth(completion : @escaping(_ result : Bool?) -> Void){
        let context = LAContext()
        
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "고객님의 소중한 정보 보호를 위해 생체인증을 진행합니다."){
            [weak self] result, error in
            DispatchQueue.main.async{
                self?.isAuthenticated = result
            }
            
            completion(result)
        }
    }
}
