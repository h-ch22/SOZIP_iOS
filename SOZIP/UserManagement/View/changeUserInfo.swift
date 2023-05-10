//
//  changeUserInfo.swift
//  SOZIP
//
//  Created by 하창진 on 2021/09/06.
//

import SwiftUI
import Firebase

struct changeUserInfo: View {
    @StateObject private var userManagement = UserManagement()
    
    @State private var phone = ""
    @State private var isPhoneEditing = false
    @State private var showOverlay = false
    @State private var showAlert = false
    @State private var result : Bool? = nil
    
    var body: some View {
        ScrollView{
            ZStack{
                Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                VStack{
                    Image(systemName: "phone.circle.fill")
                        .resizable()
                        .frame(width : 100, height : 100)
                        .foregroundColor(.btn_dark)
                    
                    Spacer().frame(height : 10)
                    
                    Text("\(Auth.auth().currentUser?.email ?? "")\n계정의 연락처를 변경합니다.")
                        .fontWeight(.semibold)
                        .foregroundColor(.txt_color)
                        .multilineTextAlignment(.center)
                    
                    Spacer().frame(height : 10)
                    
                    Text("변경할 연락처를 입력해주세요.")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer().frame(height : 20)
                    
                    HStack {
                        Image(systemName: "phone.fill")
                        
                        TextField("휴대폰 번호", text:$phone, onEditingChanged: {(editing) in
                            if editing{
                                isPhoneEditing = true
                            }
                            
                            else{
                                isPhoneEditing = false
                            }
                        }).keyboardType(.numberPad)
                        
                        Button(action: {}){
                            Text("인증번호 발송")
                                .foregroundColor(.txt_dark)
                                .font(.caption)
                        }.padding([.vertical], 5)
                        .padding([.horizontal], 10)
                        .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.btn_dark))
                    }
                    .foregroundColor(isPhoneEditing ? Color.accent : Color.txt_color)
                    .padding(20)
                    .padding([.horizontal], 20)
                    .background(RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.btn_color)
                                    .shadow(radius: 5)
                                    .padding([.horizontal],15))
                    
                    Spacer().frame(height : 20)

                    if self.phone != ""{
                        Button(action: {
                            showOverlay = true
                            
                            userManagement.updatePhone(phone : phone){ result in
                                guard let result = result else{return}
                                
                                if result{
                                    showOverlay = false
                                    self.result = true
                                    showAlert = true
                                    
                                } else{
                                    showOverlay = false
                                    self.result = false
                                    showAlert = true
                                }
                            }
                        }){
                            HStack{
                                Text("연락처 변경")
                                    .foregroundColor(.white)
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                            }.padding(20)
                                .padding([.horizontal], 100)
                                .background(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                                    .shadow(radius: 5).foregroundColor(.accent))
                        }
                    }
                }
            }
        }.background(Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
            .overlay(ProcessView().isHidden(!showOverlay))
        .navigationBarTitle(Text("사용자 정보 변경"), displayMode: .inline)
        .alert(isPresented : $showAlert){
            switch result{
            case true:
                return Alert(title: Text("연락처 업데이트 완료"),
                             message : Text("연락처가 업데이트 되었어요!"),
                             dismissButton: .default(Text("확인")))
                
            case false:
                return Alert(title: Text("오류"),
                             message : Text("요청하신 작업을 처리하는 중 문제가 발생했습니다.\n네트워크 상태, 정상 로그인 여부를 확인하거나 나중에 다시 시도하십시오."),
                             dismissButton: .default(Text("확인")))
                
            case .none:
                return Alert(title: Text(""),
                             message : Text(""),
                             dismissButton: .default(Text("확인")))
            case .some(_):
                return Alert(title: Text(""),
                             message : Text(""),
                             dismissButton: .default(Text("확인")))
            }
        }
    }
}

struct changeUserInfo_Previews: PreviewProvider {
    static var previews: some View {
        changeUserInfo()
    }
}
