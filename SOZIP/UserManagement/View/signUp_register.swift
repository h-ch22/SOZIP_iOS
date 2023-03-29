//
//  signUp_register.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/27.
//

import SwiftUI

struct signUp_register: View {
//    @Binding var img_IDCard : Image?
    @Binding var name : String
    @Binding var nickName : String
//    @Binding var studentNo : String
    @Binding var phone : String
    @Binding var marketingAccept : Bool
    
    @State private var isMailEditing = false
    
    @State private var mail = ""
    @State private var password = ""
    @State private var password_check = ""
    @State private var showProcess = false
    
    var body: some View {
        ScrollView{
            ZStack {
                Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)

                VStack {
                    Spacer().frame(height : 40)

                    Text("추가 정보를 입력해주세요.")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    
                    Spacer().frame(height : 40)
                    
                    Group{
                        HStack {
                            Image(systemName: "at.circle.fill")
                            
                            TextField("E-Mail", text:$mail, onEditingChanged: {(editing) in
                                if editing{
                                    isMailEditing = true
                                }
                                
                                else{
                                    isMailEditing = false
                                }
                                
                            })
                        }
                        .keyboardType(.emailAddress)
                        .foregroundColor(isMailEditing ? Color.accent : Color.txt_color)
                        .padding(20)
                        .padding([.horizontal], 20)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.btn_color).shadow(radius: 5)
                                        .padding([.horizontal],15))
                        
                        Spacer().frame(height : 20)

                        HStack {
                            Image(systemName: "key.fill")
                            
                            SecureField("비밀번호", text:$password)
                        }
                        .foregroundColor(Color.txt_color)
                        .padding(20)
                        .padding([.horizontal], 20)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.btn_color).shadow(radius: 5)
                                        .padding([.horizontal],15))
                        
                        Text("보안을 위해 6자 이상의 비밀번호를 설정해주세요.")
                            .foregroundColor(.gray)
                            .font(.caption)
                        
                        Spacer().frame(height : 20)

                        HStack {
                            Image(systemName: "key.fill")
                            
                            SecureField("한번 더", text:$password_check)
                        }
                        .foregroundColor(Color.txt_color)
                        .padding(20)
                        .padding([.horizontal], 20)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.btn_color).shadow(radius: 5)
                                        .padding([.horizontal],15))
                        
                        Spacer().frame(height : 20)

                        Button(action: {
                            self.showProcess = true
                        }){
                            HStack{
                                Text("가입 완료")
                                    .foregroundColor(.white)
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                            }.padding(20)
                            .padding([.horizontal], 100)
                            .background(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                                            .shadow(radius: 5).foregroundColor(.accent))
                            .disabled(self.mail.isEmpty || self.password.isEmpty || self.password_check.isEmpty || self.password.count < 6 || self.password != self.password_check || !self.mail.contains("@"))
                        }
                    }
                }
            }
        }.background(Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
        .fullScreenCover(isPresented: $showProcess, content: {
            Progress_register(name: $name, nickName: $nickName, phone: $phone, mail: $mail, password: $password, marketingAccept: $marketingAccept, helper: UserManagement())
        })
    }
}

//struct signUp_register_Previews: PreviewProvider {
//    static var previews: some View {
//        signUp_register(img_IDCard: .constant(nil))
//    }
//}
