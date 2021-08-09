//
//  ProfileListRow.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/09.
//

import SwiftUI

struct ProfileListRow : View{
    let model : ProfileListModel
    
    var body : some View{
        HStack {
            Text(model.name)
            
            Spacer()
        }.padding([.horizontal], 20)
    }
}
