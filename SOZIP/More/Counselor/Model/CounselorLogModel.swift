//
//  CounselorLogModel.swift
//  SOZIP
//
//  Created by 하창진 on 2021/09/10.
//

import SwiftUI

struct CounselorLogModel: View {
    let data : CounselorLogDataModel
    
    func convertTime() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy/MM/dd kk:mm:ss.SSSS"
        
        let date = dateFormatter.date(from: data.last_msg_date ?? "")
        
        let dateFormatter_modify = DateFormatter()
        dateFormatter_modify.dateFormat = "MM.dd HH:mm"
                
        return dateFormatter_modify.string(from: date ?? Date())
    }
    
    var body: some View {
        HStack {
            Image("ic_counselor")
                .resizable()
                .frame(width : 50, height : 50)
            
            VStack{
                HStack{
                    Text(data.SOZIPName ?? "")
                        .fontWeight(.semibold)
                        .foregroundColor(.txt_color)
                    
                    Spacer()
                    
                    Text(convertTime())
                        .font(.caption)
                        .fontWeight(.light)
                        .foregroundColor(.gray)
                }
                
                Spacer().frame(height : 5)
                
                HStack {
                    Text(data.last_msg ?? "")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    
                    Spacer()
                }
            }
        }.padding([.vertical], 20)
    }
}
