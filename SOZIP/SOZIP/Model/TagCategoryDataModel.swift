//
//  TagModel.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/30.
//

import Foundation

struct TagCategoryDataModel : Hashable{
    var category_KR : String
    var category : String
    
    init(category_KR : String, category : String){
        self.category = category
        self.category_KR = category_KR
    }
}
