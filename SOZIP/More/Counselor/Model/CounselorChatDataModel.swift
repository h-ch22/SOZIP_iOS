//
//  CounselorChatDataModel.swift
//  SOZIP
//
//  Created by 하창진 on 2021/09/10.
//

import Foundation

struct CounselorChatDataModel : Hashable{
    var docId : String?
    var msg : String?
    var msg_type : String?
    var sender : String?
    var dateTime : String?
    
    init(docId : String?, msg : String?, msg_type : String?, sender : String?, dateTime : String?){
        self.docId = docId
        self.msg = msg
        self.msg_type = msg_type
        self.sender = sender
        self.dateTime = dateTime
    }
}
