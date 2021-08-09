//
//  TagModel.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/30.
//

import SwiftUI

struct TagCategoryModel: View {
    let data : TagCategoryDataModel
    
    var body: some View {
        ZStack {
            Text(data.category_KR)
                .foregroundColor(.accent)
        }.padding(10)
        .padding([.horizontal], 10)
        .background(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(.accent))
            
    }
}

struct TagCategoryModel_Previews: PreviewProvider {
    static var previews: some View {
        TagCategoryModel(data: TagCategoryDataModel(category_KR: "전체", category: "All"))
    }
}
