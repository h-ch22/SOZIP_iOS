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
    var category : String
    var firstCome : Int
    var SOZIPName : String
    var currentPeople : Int
    var location_description : String
    var time : Date
    var Manager : String
    var participants : [String : String]
    var location : String
    var address : String
    var status : String
    var color : Color
    var account : String
    var profile : [String : String]
    var url : String?
    
    init(docId : String, SOZIPName : String, currentPeople : Int, location_description : String, time : Date, Manager : String, participants : [String : String], location : String,
         address : String, status : String, color : Color, account : String, profile : [String : String], url : String?, category : String, firstCome : Int){
        self.docId = docId
        self.SOZIPName = SOZIPName
        self.currentPeople = currentPeople
        self.location_description = location_description
        self.time = time
        self.Manager = Manager
        self.participants = participants
        self.location = location
        self.address = address
        self.status = status
        self.color = color
        self.account = account
        self.profile = profile
        self.url = url
        self.firstCome = firstCome
        self.category = category
    }
}
