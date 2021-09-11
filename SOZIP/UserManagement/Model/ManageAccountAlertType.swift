//
//  ManageAccountModalType.swift
//  SOZIP
//
//  Created by 하창진 on 2021/09/06.
//

import Foundation

enum ManageAccountAlertType : Identifiable{
    case remove, update, done_remove, error_update, done_update, error_remove, noUser
    
    var id : Int{
        hashValue
    }
}
