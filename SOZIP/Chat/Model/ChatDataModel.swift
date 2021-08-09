//
//  ChatDataModel.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/04.
//

import Foundation
import SwiftUI

struct ChatDataModel : Hashable{
    var rootDocId : String
    var docId : String
    var time : String
    var sender : String
    var unread : [String]
    var type : String
    var msg : String
    var participants : [String : String]
    var items : [String?]
    var index : Int?
    
    init(rootDocId : String, docId : String, time : String, sender : String, unread : [String], type : String, msg : String, participants : [String : String], items : [String?], index : Int?){
        self.rootDocId = rootDocId
        self.docId = docId
        self.time = time
        self.sender = sender
        self.unread = unread
        self.type = type
        self.msg = msg
        self.participants = participants
        self.items = items
        self.index = index
    }
}
