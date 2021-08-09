//
//  validateResultModel.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/29.
//

import Foundation

enum validateResultModel : Identifiable{
    case success, fail, error
    
    var id : Int{
        hashValue
    }
}
