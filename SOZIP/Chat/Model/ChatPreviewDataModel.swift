//
//  ChatPreviewDataModel.swift
//  ChatPreviewDataModel
//
//  Created by 하창진 on 2021/08/05.
//

import Foundation
import SwiftUI

struct ChatPreviewDataModel : Hashable{
    var docId : String
    var currentPeople : Int
    var status : String
    var name : String
    var last_msg : String
    var last_msg_type : String
    var last_msg_time : String
    
    init(docId : String, currentPeople : Int, status : String, name : String, last_msg : String, last_msg_type : String, last_msg_time : String){
        self.docId = docId
        self.currentPeople = currentPeople
        self.status = status
        self.name = name
        self.last_msg = last_msg
        self.last_msg_type = last_msg_type
        self.last_msg_time = last_msg_time
    }
}
