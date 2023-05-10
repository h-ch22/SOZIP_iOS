//
//  Progress_register.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/28.
//

import SwiftUI

struct Progress_register: View {
//    @Binding var img_IDCard : Image?
    @Binding var name : String
    @Binding var nickName : String
    @Binding var studentNo : String
    @Binding var phone : String
    @Binding var mail : String
    @Binding var password : String
    @Binding var marketingAccept : Bool
    
    @ObservedObject var helper : UserManagement
    
    @State private var result : signUpResultModel?
    @State private var isAnimating = false
//    @State private var school = "jbnu"

    var foreverAnimation: Animation {
        Animation.linear(duration: 2.0)
            .repeatForever(autoreverses: false)
    }
    
    var body: some View {
        ZStack {
            Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            VStack{
                Spacer()
                
                ZStack{
                    Image("appstore")
                        .resizable()
                        .frame(width: 150, height: 150, alignment: .center)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(radius: 5)
                }

                Text("가입 처리 중...")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.txt_color)
                
                Text("고객님의 가입 요청을 처리하고 있습니다.\n잠시 기다려주세요!")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.txt_color)
                
                Spacer()
                
                ProgressView()
                
                Spacer().frame(height : 10)
                
                Text("네트워크 상태에 따라 최대 1분 정도 소요될 수 있어요.")
                    .foregroundColor(.gray)
            }
        }.fullScreenCover(item: $result){item in
            switch item{
            case .success:
                Register_Success()
                
            case .invalidEmail:
                signUp_Fail(errorMsg : "잘못된 형식의 E-Mail 입니다.")
                
            case .AlreadyInUse:
                signUp_Fail(errorMsg : "이미 사용 중인 E-Mail 입니다.")

            case .NotAllowed:
                signUp_Fail(errorMsg : "E-Mail 가입이 허용되지 않았습니다.\n이제이 고객센터 (ejaye@naver.com)에 문의해주세요.")

            case .WeakPassword:
                signUp_Fail(errorMsg : "보안에 취약한 비밀번호입니다.\n6자리 이상의 비밀번호를 설정해주세요.")

            case .noMetaData:
                signUp_Fail(errorMsg : "이미지 업로드를 위한 MetaData가 정의되어 있지 않습니다.\n나중에 다시 시도해주세요.")
                
            case .fail:
                signUp_Fail(errorMsg : "알 수 없는 오류로 인해 가입이 처리되지 않았습니다.\n나중에 다시 시도하시거나, 이제이 고객센터 (ejaye@naver.com)에 문의해주세요.")

            }
        }
        
        .onAppear(perform: {
            helper.signUp(mail: mail, password: password, name: name, nickName: nickName, phone: phone, marketingAccept : marketingAccept, studentNo : studentNo){result in

                guard let result = result else{return}

                if result == "success"{
                    self.result = .success
                }

                else if result.contains("already in use by another account"){
                    self.result = .AlreadyInUse
                }

                else if result.contains("invalid"){
                    self.result = .invalidEmail
                }

                else if result.contains("allowed"){
                    self.result = .NotAllowed
                }

                else if result.contains("weak"){
                    self.result = .WeakPassword
                }

                else if result.contains("metadata"){
                    self.result = .noMetaData
                }

                else{
                    self.result = .fail
                }
            }
        })
    }
}

struct Progress_register_previews : PreviewProvider{
    static var previews: some View{
        Progress_register(name: .constant(""), nickName: .constant(""), studentNo: .constant(""), phone: .constant(""), mail: .constant(""), password: .constant(""), marketingAccept: .constant(true), helper: UserManagement())
    }
}
