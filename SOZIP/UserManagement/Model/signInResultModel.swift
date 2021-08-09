//
//  signInResultModel.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/30.
//

import Foundation

enum signInResultModel : Identifiable{
    case success, noNetwork, disabled, fail, error, noField
    
    var id : Int{
        hashValue
    }
}
