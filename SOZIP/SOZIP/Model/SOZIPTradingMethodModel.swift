//
//  SOZIPTradingMethodModel.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/02.
//

import Foundation

enum SOZIPTradingMethodModel : Identifiable{
    case meet, nomeet
    
    var id : Int{
        hashValue
    }
}
