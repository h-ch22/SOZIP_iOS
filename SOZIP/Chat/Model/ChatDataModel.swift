//
//  ChatDataModel.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/25.
//

import Foundation
import SwiftUI

struct ChatDataModel : Hashable{
    var rootDocId : String
    var docId : String
    var msg : String
    var sender : String
    var unread : Int
    var time : String
    var type : String
    var imageIndex : Int?
    var profile : String
    var profile_BG : Color
    var nickName : String
    var url : [String]
    var account : String?
    
    init(rootDocId : String, docId : String, msg : String, sender : String, unread : Int, time : String, type : String, imageIndex : Int?, profile : String, profile_BG : Color, nickName : String, url : [String], account : String?){
        self.rootDocId = rootDocId
        self.docId = docId
        self.msg = msg
        self.sender = sender
        self.unread = unread
        self.time = time
        self.type = type
        self.imageIndex = imageIndex
        self.profile = profile
        self.profile_BG = profile_BG
        self.nickName = nickName
        self.url = url
        self.account = account
    }
}
