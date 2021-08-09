//
//  ChatListModel.swift
//  ChatListModel
//
//  Created by 하창진 on 2021/08/04.
//

import SwiftUI

struct ChatPreviewListModel: View {
    let data : ChatPreviewDataModel

    var body: some View {
        VStack{
            
            if data.currentPeople > 0 {
                Rectangle()
                    .fill(data.color)
                    .frame(height : 3)
                    .edgesIgnoringSafeArea(.horizontal)
                
                HStack{
                    Text(data.name)
                        .fontWeight(.semibold)
                        .foregroundColor(.txt_color)
                    
                    Spacer().frame(width : 10)
                    
                    Text(String(data.currentPeople))
                        .foregroundColor(.gray)
                        .font(.caption)
                    
                    Spacer()
                }
                
                Spacer().frame(height : 10)

                HStack{
                    Text(data.last_msg)
                        .font(.caption)
                        .foregroundColor(.gray)

                    Spacer()
                    
                    Text(String(data.last_msg_time))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            else{
                HStack{
                    Text(data.name)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Spacer()

                }
                
                Spacer().frame(height : 10)

                HStack{
                    Text("종료된 소집입니다.")
                        .font(.caption)
                        .foregroundColor(.white)

                    Spacer()
                }
            }
            

        }.padding(20)
            .background(RoundedRectangle(cornerRadius: 15.0).shadow(radius: 5).foregroundColor(data.currentPeople > 0 ? .btn_color : .black.opacity(0.6)))
        
    }
}
