//
//  FeedbackHubManagerDataModel.swift
//  SOZIP
//
//  Created by 하창진 on 2021/09/10.
//

import Foundation

struct FeedbackHubManagerDataModel : Hashable{
    var title : String
    var contents : String
    var category : String
    var date : String
    var answer : String?
    var docId : String
    var sender : String
    
    init(title : String, contents : String, category : String, date : String, answer : String?, docId : String, sender : String){
        self.title = title
        self.contents = contents
        self.category = category
        self.date = date
        self.answer = answer
        self.docId = docId
        self.sender = sender
    }
}
