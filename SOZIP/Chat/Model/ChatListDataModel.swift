//
//  ChatListDataModel.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/23.
//

import Foundation
import SwiftUI

struct ChatListDataModel : Hashable{
    var docId : String
    var SOZIPName : String
    var currentPeople : Int
    var last_msg : String
    var participants : [String : String]
    var status : String
    var profiles : [String : String]
    var color : Color
    var last_msg_time : String
    var Manager : String
    
    
    init(docId : String, SOZIPName : String, currentPeople : Int, last_msg : String, participants : [String : String], status : String, profiles : [String : String], color : Color, last_msg_time : String, Manager : String){
        self.docId = docId
        self.SOZIPName = SOZIPName
        self.currentPeople = currentPeople
        self.last_msg = last_msg
        self.participants = participants
        self.profiles =  profiles
        self.status = status
        self.color = color
        self.last_msg_time = last_msg_time
        self.Manager = Manager
    }
}
