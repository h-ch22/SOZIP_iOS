//
//  registerResultModel.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/28.
//

import Foundation

enum ResultModel : Identifiable{
    case success, fail
    
    var id: Int{
        hashValue
    }
}
