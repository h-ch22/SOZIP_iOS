//
//  signUpResultModel.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/29.
//

import Foundation

enum signUpResultModel : Identifiable{
    case invalidEmail, AlreadyInUse, NotAllowed, WeakPassword, noMetaData, success, fail
    
    var id: Int{
        hashValue
    }
}
