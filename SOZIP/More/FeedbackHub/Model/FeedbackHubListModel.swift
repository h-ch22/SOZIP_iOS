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
                            .font(.caption)
                            .foregroundColor(.txt_color)
                        
                        Text("칭찬해요")
                            .foregroundColor(.txt_color)
                            .font(.caption)

                    case "개선해주세요":
                        Image(systemName: "chevron.right.2")
                            .rotationEffect(Angle(degrees: -90))
                            .font(.caption)
                            .foregroundColor(.txt_color)

                        Text("개선해주세요")
                            .foregroundColor(.txt_color)
                            .font(.caption)

                    case "궁금해요" :
                        Image(systemName: "questionmark.circle.fill")
                            .foregroundColor(.txt_color)
                            .font(.caption)

                        Text("궁금해요")
                            .foregroundColor(.txt_color)
                            .font(.caption)

                    default :
                        EmptyView()
                    }
                    
                    Spacer()
                    
                    Text(data.date)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer().frame(height : 5)

                HStack {
                    Text(data.title)
                        .foregroundColor(.txt_color)
                        .fontWeight(.semibold)
                    
                    Spacer()
                }
                
                if data.answer != ""{
                    Spacer().frame(height : 5)

                    HStack {
                        Text("피드백에 대한 답변이 등록되었어요.")
                            .foregroundColor(.accent)
                            .font(.caption)
                        
                        Spacer()
                    }
                }
            }
        }.padding(20)
    }
}

struct FeedbackHubListModel_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackHubListModel(data : FeedbackHubItemModel(title: "title", contents: "contents", category: "궁금해요", date: "7/12 09:00", answer: "", docId: ""))
    }
}
