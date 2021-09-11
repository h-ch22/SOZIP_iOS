//
//  CounselorLogDataModel.swift
//  SOZIP
//
//  Created by 하창진 on 2021/09/10.
//

import Foundation

struct CounselorLogDataModel : Hashable{
    var docId : String?
    var last_msg : String?
    var last_msg_type : String?
    var last_msg_date : String?
    var SOZIPName : String?
    var SOZIPId : String?
    
    init(docId : String?, last_msg : String?, last_msg_type : String?, last_msg_date : String?, SOZIPName : String?, SOZIPId : String?){
        self.docId = docId
        self.last_msg = last_msg
        self.last_msg_type = last_msg_type
        self.last_msg_date = last_msg_date
        self.SOZIPName = SOZIPName
        self.SOZIPId = SOZIPId
    }
}
