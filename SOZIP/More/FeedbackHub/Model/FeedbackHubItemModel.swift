//
//  FeedbackHubItemModel.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/30.
//

import Foundation

struct FeedbackHubItemModel : Hashable{
    var title : String
    var contents : String
    var category : String
    var date : String
    var answer : String?
    var read : Bool?
    
    init(title : String, contents : String, category : String, date : String, answer : String?, read : Bool?){
        self.title = title
        self.contents = contents
        self.category = category
        self.date = date
        self.answer = answer
        self.read = read
    }
}
