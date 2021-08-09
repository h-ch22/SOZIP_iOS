//
//  Tutorial_Validate.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/27.
//

import SwiftUI

struct Tutorial_Validate: View {
    @State private var current = 0
    @Environment(\.presentationMode) var presentationMode
    let model : TutorialScreenViewModel
    static var detail : [String] = []
    static var title : [String] = []
    @State private var bgColor : [Color] = [.tutorial_color_1, .tutorial_color_2, .tutorial_color_3]
    @State private var imgs : [String] = ["tutorialImg_1", "tutorialImg_2", "tutorialImg_3"]
    
    static func setContents(model : TutorialScreenViewModel){
        switch model{
        case .mobile:
            Tutorial_Validate.title = [
                "1. 학생증 로드 방법 선택하기",
                "2. 실물 학생증 촬영하기",
                "3. 학생증 수정하기"
            ]
            
            Tutorial_Validate.detail = [
                "학생증 촬영하기 버튼을 클릭하세요!",
                "인적사항이 잘 보이게 학생증을 촬영해주세요!",
                "학생증의 인적 사항 부분이 보이도록 크기를 조절해주세요!"
            ]
            
        case .real:
            Tutorial_Validate.title = [
                "1. 학생증 로드 방법 선택하기",
                "2. 학생증 캡처하기",
                "3. 학생증 수정하기"
            ]
            
            Tutorial_Validate.detail = [
                "모바일 학생증 앱 열기 버튼을 클릭하세요!",
                "모바일 학생증을 캡처하고 앱으로 돌아와서 학생증을 불러와주세요!",
                "학생증의 인적 사항 부분이 보이도록 크기를 조절해주세요!"
            ]
        }
    }

    var body: some View {
        NavigationView{
            ZStack{
                Tutorial_ScreenView(img: imgs[current], title: Tutorial_Validate.title[current], detail: Tutorial_Validate.detail[current], bgColor: bgColor[current])
            }.overlay(
                Button(action: {
                    withAnimation(.easeInOut){
                        if current < 2{
                            current += 1
                        }
                        
                        else{
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }, label: {
                    if current < 2{
                        Image(systemName: "chevron.right")
                            .font(.system(size: 20, weight : .semibold))
                            .foregroundColor(.black)
                            .frame(width: 60, height: 60)
                            .background(Color.white)
                            .clipShape(Circle())
                            .overlay(
                                ZStack{
                                    Circle()
                                        .stroke(Color.black.opacity(0.04), lineWidth: 4)
                                    
                                    Circle()
                                        .trim(from: 0, to: CGFloat(current+1) / CGFloat(3))
                                        .stroke(Color.white, lineWidth: 4)
                                        .rotationEffect(.init(degrees: -90))
                                }.padding(-15)
                            )
                    }
                    
                    else{
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight : .semibold))
                            .foregroundColor(.black)
                            .frame(width: 60, height: 60)
                            .background(Color.white)
                            .clipShape(Circle())
                            .overlay(
                                ZStack{
                                    Circle()
                                        .stroke(Color.black.opacity(0.04), lineWidth: 4)
                                    
                                    Circle()
                                        .trim(from: 0, to: CGFloat(current+1) / CGFloat(3))
                                        .stroke(Color.white, lineWidth: 4)
                                        .rotationEffect(.init(degrees: -90))
                                }.padding(-15)
                            )
                    }

                }).padding(.bottom, 20)
                ,alignment: .bottom
            )
            
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(trailing: Button("닫기"){
                self.presentationMode.wrappedValue.dismiss()
            })
        }

    }
}

//struct Tutorial_Validate_Previews: PreviewProvider {
//    static var previews: some View {
//        Tutorial_Validate()
//    }
//}
