//
//  addSOZIPResultModel.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/02.
//

import Foundation

enum addSOZIPResultModel : Identifiable{
    case error, success, emptyField
    
    var id : Int{
        hashValue
    }
}
