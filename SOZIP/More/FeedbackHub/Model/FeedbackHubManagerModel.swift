//
//  FeedbackHubManagerModel.swift
//  SOZIP
//
//  Created by 하창진 on 2021/09/10.
//

import Foundation

enum FeedbackHubManagerModel : Identifiable{
    case answer_uploaded, write_answer, edit_answer, answer_upload_fail, noPermission, error, blankField, same_answer
    
    var id : Int{
        hashValue
    }
}
