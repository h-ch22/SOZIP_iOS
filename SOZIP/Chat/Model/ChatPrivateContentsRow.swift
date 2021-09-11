//
//  ChatPrivateContentsRow.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/25.
//

import SwiftUI

struct ChatPrivateContentsRow: View {
    var SOZIPData : ChatListDataModel
    var data : ChatDataModel
    
    func convertTime() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy/MM/dd kk:mm:ss.SSSS"
        
        let date = dateFormatter.date(from: data.time)
        
        let dateFormatter_modify = DateFormatter()
        dateFormatter_modify.dateFormat = "HH:mm"
        
        return dateFormatter_modify.string(from: date ?? Date())
    }
    
    var body: some View {
        VStack{
            HStack{
                Text(data.profile)
                    .modifier(FittingFontSizeModifier())
                    .frame(width : 25, height : 25)
                    .padding(5)
                    .background(Circle().foregroundColor(data.profile_BG))
                
                Text(data.nickName)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
            }
            
            HStack{
                
                VStack{
                    Image(systemName : "lock.circle.fill")
                        .resizable()
                        .frame(width : 50, height : 50)
                        .foregroundColor(.white)
                    
                    Spacer().frame(height : 15)

                    Text("만나서 현금을 지급해주세요!")
                        .fontWeight(.semibold)
                        .font(.title2)
                        .foregroundColor(.white)
                    
                    Spacer().frame(height : 15)
                    
                    Text("계좌 정보는 계좌로 지급을 선택한 소집 멤버에게만 표시됩니다.")
                        .foregroundColor(.white)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal : false, vertical : true)
                }.padding()
                .background(Color.gray)
                .clipShape(BubbleShape(myMessage: false))
                .foregroundColor(.white)
                
                Spacer().frame(width : 10)
                
                VStack {
                    
                    Spacer()
                    
                    Text(convertTime())
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
            }
            
            
            
        }
    }
}
