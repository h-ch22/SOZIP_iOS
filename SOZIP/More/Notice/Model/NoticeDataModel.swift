//
//  NoticeListDataModel.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/27.
//

import SwiftUI

struct NoticeDataModel : Hashable{
    var docId : String
    var noticeTitle : String
    var contents : String
    var timeStamp : String
    var imageId : String?
    var imageIndex : Int?
    var url : String?
    
    init(docId : String, noticeTitle : String, contents : String, timeStamp : String, imageId : String?, imageIndex : Int?, url : String?){
        self.docId = docId
        self.noticeTitle = noticeTitle
        self.contents = contents
        self.timeStamp = timeStamp
        self.imageId = imageId
        self.imageIndex = imageIndex
        self.url = url
    }
}
