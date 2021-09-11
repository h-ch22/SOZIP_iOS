//
//  changePasswordAlertModel.swift
//  SOZIP
//
//  Created by 하창진 on 2021/09/06.
//

import Foundation

enum changePasswordAlertModel : Identifiable{
    case limit, done, error, noUser, confirm, noMatch, noMatchPW, invalidEmail, networkError
    
    var id : Int{
        hashValue
    }
}
