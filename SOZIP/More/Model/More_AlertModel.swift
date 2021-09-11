//
//  More_AlertModel.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/28.
//

import Foundation

enum More_AlertModel : Identifiable{
    case signOut, secession, greet, noUser, secessionFail, signOutFail, updateSuccess, updateFail
    
    var id: Int{
        hashValue
    }
}
