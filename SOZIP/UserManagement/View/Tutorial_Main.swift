//
//  Tutorial_Main.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/02.
//

import SwiftUI

struct Tutorial_Main: View {
    @State private var showTutorial = false
    @State private var showMobileTutorial = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView{
            ZStack {
                Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
                VStack {
                    Text("반가워요!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.txt_color)
                    
                    Text("원하시는 인증 방법을 선택해보세요!")
                        .foregroundColor(.txt_color)
                    
                    Spacer().frame(height : 60)

                    Button(action : {
                        Tutorial_Validate.setContents(model: .real)
                        self.showTutorial = true
                    }){
                        HStack {
                            VStack(alignment : .leading){
                                Text("실물 학생증이 있나요?")
                                    .font(.caption)
                                    .foregroundColor(.txt_color)
                                
                                Text("실물 학생증 인증 방법 보기")
                                    .foregroundColor(.txt_color)
                            }
                            
                            Spacer().frame(width : 90)
                            
                            Image(systemName: "arrow.forward.circle.fill")
                                .resizable()
                                .frame(width : 30, height : 30)
                                .foregroundColor(.txt_color)
                        }.padding(20)
                        .frame(width : UIScreen.main.bounds.width / 1.2)
                        .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btn_color).shadow(radius: 5))
                    }.sheet(isPresented: $showTutorial, content: {
                        Tutorial_Validate(model : .real)
                    })
                    
                    Spacer().frame(height : 20)
                    
                    Button(action : {
                        Tutorial_Validate.setContents(model: .mobile)
                        self.showMobileTutorial = true
                    }){
                        HStack {
                            VStack(alignment : .leading){
                                Text("전북대앱/모바일 도서관으로 인증할까요?")
                                    .font(.caption)
                                    .foregroundColor(.txt_color)

                                Text("모바일 학생증 인증 방법 보기")
                                    .foregroundColor(.txt_color)
                            }
                            
                            Spacer().frame(width : 90)
                            
                            Image(systemName: "arrow.forward.circle.fill")
                                .resizable()
                                .frame(width : 30, height : 30)
                                .foregroundColor(.txt_color)
                            
                        }.padding(20)
                        .frame(width : UIScreen.main.bounds.width / 1.2)
                        .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btn_color).shadow(radius: 5))
                    }.sheet(isPresented: $showMobileTutorial, content: {
                        Tutorial_Validate(model : .mobile)
                    })
                    
                    .navigationBarTitle(Text("튜토리얼"), displayMode: .inline)
                    .navigationBarItems(trailing: Button("닫기"){self.presentationMode.wrappedValue.dismiss()})
                }
            }
        }
        
    }
}

struct Tutorial_Main_Previews: PreviewProvider {
    static var previews: some View {
        Tutorial_Main()
    }
}
