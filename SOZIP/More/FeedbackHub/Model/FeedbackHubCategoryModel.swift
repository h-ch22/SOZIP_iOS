//
//  FeedbackHubCategoryModel.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/30.
//

import Foundation

enum FeedbackHubCategoryModel : Identifiable{
    case heart, improve, question
    
    var id: Int{
        hashValue
    }
}
