//
//  ATTModel.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/04.
//

import Foundation

enum ATTModel : Identifiable{
    case home, ATT
    
    var id : Int{
        hashValue
    }
}
