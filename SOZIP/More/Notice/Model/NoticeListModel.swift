//
//  NoticeListModel.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/27.
//

import SwiftUI

struct NoticeListModel : View{
    let data : NoticeDataModel
    
    var body : some View{
        VStack {
            HStack {
                Text(data.noticeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.txt_color)
                
                Spacer()
            }
            
            Spacer().frame(height : 5)
            
            HStack{
                Text(data.timeStamp)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
            }
            
            Spacer().frame(height : 5)
        }
    }
}
