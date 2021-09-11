//
//  FeedbackDetailView.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/27.
//

import SwiftUI

struct FeedbackDetailView: View {
    let data : FeedbackHubItemModel
    
    var body: some View {
        ZStack{
            Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            VStack{
                Spacer().frame(height : 15)
                
                HStack{
                    Text(data.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.txt_color)
                    
                    Spacer()
                }
                
                Spacer().frame(height : 5)
                
                HStack{
                    Text(data.date)
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    switch (data.category){
                    case "칭찬해요":
                        Image(systemName: "heart.fill")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text("칭찬해요")
                            .foregroundColor(.gray)
                            .font(.caption)

                    case "개선해주세요":
                        Image(systemName: "chevron.right.2")
                            .rotationEffect(Angle(degrees: -90))
                            .font(.caption)
                            .foregroundColor(.gray)

                        Text("개선해주세요")
                            .foregroundColor(.gray)
                            .font(.caption)

                    case "궁금해요" :
                        Image(systemName: "questionmark.circle.fill")
                            .foregroundColor(.gray)
                            .font(.caption)

                        Text("궁금해요")
                            .foregroundColor(.gray)
                            .font(.caption)

                    default :
                        EmptyView()
                    }
                }
                
                Divider()
                
                ScrollView{
                    VStack{
                        HStack{
                            Text(data.contents)
                                .foregroundColor(.txt_color)
                                .lineSpacing(/*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/)
                                .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                            
                            Spacer()
                        }
                    }
                    
                    Spacer().frame(height : 15)
                    
                    if data.answer == ""{
                        Text("아직 이 피드백에 대한 답변이 등록되지 않았습니다.")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundColor(.gray)
                    }
                    
                    else{
                        VStack{
                            Text("피드백에 대한 답변입니다.")
                                .fontWeight(.semibold)
                            
                            Spacer().frame(height : 10)

                            Text(data.answer!)
                                .foregroundColor(.txt_color)
                                .lineSpacing(/*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/)
                                .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                        }.padding(20).background(RoundedRectangle(cornerRadius: 15.0).shadow(radius: 5).foregroundColor(.btn_color))
                    }
                }
            }.padding([.horizontal], 20)
            .navigationBarTitle(data.title, displayMode: .inline)
        }
    }
}

//struct FeedbackDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        FeedbackDetailView()
//    }
//}
