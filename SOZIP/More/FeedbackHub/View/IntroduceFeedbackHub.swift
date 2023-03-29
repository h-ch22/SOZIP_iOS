//
//  IntroduceFeedbackHub.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/08.
//

import SwiftUI

struct IntroduceFeedbackHub: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView{
            VStack{
                Image("ic_feedbackHub")
                    .resizable()
                    .frame(width : 150, height : 150)
                
                Text("소집 : SOZIP 베타 시작하기")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.txt_color)
                
                Spacer().frame(height : 20)
                
                Text("소집 : SOZIP 베타를 사용하시게 된 것을 환영합니다.\n소집 : SOZIP의 여러 기능들을 마음껏 즐겨보세요!\n개선할 점이 발견되면, [더 보기]의 피드백 허브를 이용해주세요.\n\n이제이 소프트웨어 개선 프로그램에 참여해주셔서 감사합니다.")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                
                Spacer().frame(height : 20)
                
                Button(action : {
                    UserDefaults.standard.setValue(true, forKey: "launchedBefore")
                    self.presentationMode.wrappedValue.dismiss()
                }){
                    HStack {
                        Text("시작하기")
                            .foregroundColor(.white)
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white)
                    }.padding(20)
                    .padding([.horizontal], 60)
                    .background(RoundedRectangle(cornerRadius: 25).foregroundColor(.accent).shadow(radius: 5))
                }
            }.navigationBarHidden(true)
        }

    }
}

struct IntroduceFeedbackHub_Previews: PreviewProvider {
    static var previews: some View {
        IntroduceFeedbackHub()
    }
}
