//
//  Tutorial_ScreenView.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/27.
//

import SwiftUI

struct Tutorial_ScreenView: View {
    var img : String
    var title : String
    var detail : String
    var bgColor : Color
    
    @State private var current = 1
    
    var body: some View {
        ZStack{
            bgColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            VStack{
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Spacer().frame(height : 20)
                
                Image(img)
                    .resizable()
                    .frame(width: 350, height: 350, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
                Spacer().frame(height : 20)
                
                Text(detail)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
            }
        }
    }
}

struct Tutorial_ScreenView_Previews : PreviewProvider{
    static var previews: some View{
        Tutorial_ScreenView(img: "tutorialImg_3", title: "1. 학생증 로드 방법 선택하기", detail: "학생증의 로드 방식을 선택하세요.\n캡처한 모바일 학생증 또는 촬영한 실물 학생증이 있으면 학생증 로드,\n실물 학생증을 촬영하려면 학생증 촬영,\n모바일 학생증 앱을 실행하려면 모바일 학생증 앱 열기를 누르세요!", bgColor: .tutorial_color_1)
    }
}
