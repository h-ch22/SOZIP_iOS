//
//  SOZIPDataModel.swift
//  SOZIPDataModel
//
//  Created by 하창진 on 2021/07/31.
//

import Foundation
import SwiftUI

struct SOZIPDataModel : Hashable{
    var docId : String
    var tags : [String]
    var SOZIPName : String
    var currentPeople : Int
    var location_description : String
    var SOZIP_Color : Color
    var store : String
    var time : Date
    var Manager : String
    var participants : [String : String]
    var location : String
    var address : String
    var status : String
    var payMethod : [String : String]
    var transactionMethod : [String : String]
    
    init(docId : String, tags : [String], SOZIPName : String, currentPeople : Int, location_description : String, SOZIP_Color : Color, store : String, time : Date, Manager : String, participants : [String : String], location : String,
         address : String, status : String, payMethod : [String : String], transactionMethod : [String : String]){
        self.docId = docId
        self.tags = tags
        self.SOZIPName = SOZIPName
        self.currentPeople = currentPeople
        self.location_description = location_description
        self.SOZIP_Color = SOZIP_Color
        self.store = store
        self.time = time
        self.Manager = Manager
        self.participants = participants
        self.location = location
        self.address = address
        self.status = status
        self.payMethod = payMethod
        self.transactionMethod = transactionMethod
    }
}
