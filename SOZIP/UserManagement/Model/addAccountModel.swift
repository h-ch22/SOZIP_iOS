//
//  addAccountModel.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/24.
//

import Foundation

enum addAccountModel : Identifiable{
    case success, error, noUser, emptyField
    
    var id : Int{
        hashValue
    }
}
