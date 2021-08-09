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
            VStack{
                HStack{
                    if data.name.contains("치킨") || data.name.contains("BHC") || data.name.contains("BBQ") || data.name.contains("네네") || data.name.contains("황금올리브") || data.name.contains("허니콤보") || data.name.contains("뿌링클"){
                        Image("ic_chicken")
                            .resizable()
                            .frame(width : 50, height : 50)
                    }
                    
                    else if data.name.contains("피자"){
                        Image("ic_pizza")
                            .resizable()
                            .frame(width : 50, height : 50)
                    }
                    
                    else if data.name.contains("버거") || data.name.contains("맥도날드") || data.name.contains("버거킹") || data.name.contains("롯데리아") || data.name.contains("맘스터치"){
                        Image("profile_burger")
                            .resizable()
                            .frame(width : 50, height : 50)
                    }
                    
                    else{
                        Image("appstore")
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .frame(width : 50, height : 50)
                    }
                    
                    VStack{
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
                }
                
                
            }
            
            
            
            
        }
        
    }
}
