//
//  Process_signUp.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/24.
//

import SwiftUI

struct Process_Validate: View {
    @Binding var image : Image?
    @Binding var studentNo : String
    @Binding var name : String
    @Binding var phone : String
    @Binding var nickName : String
    @Binding var marketingAccept : Bool
    @ObservedObject var helper : validateIDCard
    @Environment(\.presentations) private var presentations

    @State private var validateResult : validateResultModel?
    @State private var isAnimating = false
    var foreverAnimation: Animation {
        Animation.linear(duration: 2.0)
            .repeatForever(autoreverses: false)
    }
    
    static var errorCode = ""
    
    var body: some View {
        ZStack {
            Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            VStack{
                Spacer()
                
                ZStack{
                    Image("ic_register_process_bg")
                        .resizable()
                        .frame(width: 200, height: 200, alignment: .center)
                    
                    Image("ic_process_register")
                        .resizable()
                        .frame(width: 70, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .rotationEffect(Angle(degrees: self.isAnimating ? 360 : 0.0))
                                            .animation(self.isAnimating ? foreverAnimation : .default)
                                            .onAppear { self.isAnimating = true }
                }

                Text("학적 사항 확인 중...")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.txt_color)
                
                Text("학적 사항을 확인하고 있습니다.\n잠시 기다려주세요!")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.txt_color)
                
                Spacer()
                
                
                Text("네트워크 상태에 따라 최대 1분 정도 소요될 수 있어요.")
                    .foregroundColor(.gray)
            }
        }.fullScreenCover(item: $validateResult){item in
            switch item{
            case .success:
                signUp_register(name : $name, nickName: $nickName, studentNo: $studentNo, phone : $phone, marketingAccept: $marketingAccept)
                
            case .fail:
                Process_Fail(msg: "학생증에 기재된 학적 사항과 입력한 학적 사항이 일치하지 않습니다.", errorCode: "")

            case .error:
                Process_Fail(msg: "오류가 발생했습니다.\n나중에 다시 시도하시거나, 이제이 고객센터 (ejaye@naver.com)에 문의해주세요.", errorCode: Process_Validate.errorCode)
            }
        }
        
        .onAppear(perform: {
            helper.validate(image: self.image?.asUIImage(), studentNo: self.studentNo, name: self.name){(result) in
                guard let result = result else{return}
                
                if result == "success"{
                    self.validateResult = .success
                }
                
                else if result == "fail"{
                    self.validateResult = .fail
                }

                else{
                    Process_Validate.errorCode = result
                    self.validateResult = .error
                }
            }
        })
    }
}

//struct Process_Validate_Previews: PreviewProvider {
//    static var previews: some View {
//        Process_Validate(image: .constant(nil), studentNo: .constant(""), name: .constant(""), phone: .constant(""), nickName: .constant(""), helper: validateIDCard())
//    }
//}
