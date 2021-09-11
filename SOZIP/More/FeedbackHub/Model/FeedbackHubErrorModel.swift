//
//  FeedbackHubErrorModel.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/30.
//

import Foundation

enum FeedbackHubErrorModel : Identifiable{
    case success, error, noUser, noContents, noCategory
    
    var id : Int{
        hashValue
    }
}
