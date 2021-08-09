//
//  FeedbackHubListModel.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/30.
//

import SwiftUI

struct FeedbackHubListModel: View {
    let data : FeedbackHubItemModel
    
    var body: some View {
        VStack{
            Group {
                HStack{
                    switch (data.category){
                    case "칭찬해요":
                        Image(systemName: "heart.fill")
                            .foregroundColor(.txt_color)
                        
                        Text("칭찬해요")
                            .foregroundColor(.txt_color)

                    case "개선해주세요":
                        Image(systemName: "chevron.right.2")
                            .rotationEffect(Angle(degrees: -90))
                            .foregroundColor(.txt_color)

                        Text("개선해주세요")
                            .foregroundColor(.txt_color)

                    case "궁금해요" :
                        Image(systemName: "questionmark.circle.fill")
                            .foregroundColor(.txt_color)

                        Text("궁금해요")
                            .foregroundColor(.txt_color)

                    default :
                        EmptyView()
                    }
                    
                    Spacer()
                    
                    Text(data.date)
                }
                
                Spacer().frame(height : 5)

                HStack {
                    Text(data.title)
                        .foregroundColor(.txt_color)
                        .fontWeight(.bold)
                        .font(.title2)
                    
                    Spacer()
                }
                
                if data.answer != nil{
                    Spacer().frame(height : 5)

                    HStack {
                        Text("피드백에 대한 답변이 등록되었어요.")
                            .font(.caption)
                        
                        Spacer()
                    }
                }
            }
        }.padding(30)
        .background(
            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                .foregroundColor(data.read != nil && !data.read! ? .accentColor : .clear)
                .opacity(0.4)
                .padding([.horizontal], 10)
        )
    }
}

struct FeedbackHubListModel_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackHubListModel(data : FeedbackHubItemModel(title: "title", contents: "contents", category: "궁금해요", date: "7/12 09:00", answer: "", read: false))
    }
}
