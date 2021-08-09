//
//  ChatModalModel.swift
//  ChatModalModel
//
//  Created by 하창진 on 2021/08/06.
//

import Foundation

enum ChatModalModel : Identifiable{
    case info, report
    
    var id : Int{
        hashValue
    }
}
