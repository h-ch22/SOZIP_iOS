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
    @Binding var studentNo : String
    @Binding var phone : String
    @Binding var marketingAccept : Bool
    
    @State private var isMailEditing = false
    @State private var mail = ""
    @State private var password = ""
    @State private var password_check = ""
    @State private var showProcess = false
    @State private var school : String? = nil
    @State private var isValidEmailFormat = true
    @State private var showModal = false
    @State private var isSupportSchool = false
    
    @StateObject private var helper = UserManagement()
    
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
                            
                            TextField("대학 E-Mail", text:$mail, onEditingChanged: {(editing) in
                                if editing{
                                    isMailEditing = true
                                }
                                
                                else{
                                    isMailEditing = false
                                    
                                    if mail != ""{
                                        if !mail.contains("@"){
                                            isValidEmailFormat = false
                                        } else{
                                            isValidEmailFormat = true
                                            school = helper.getSchoolName(email: mail)
                                            
                                            isSupportSchool = (school == nil) ? false : true
                                        }
                                    }
                                }
                                
                            })
                        }
                        .keyboardType(.emailAddress)
                        .foregroundColor(isMailEditing ? Color.accent : Color.txt_color)
                        .padding(20)
                        .padding([.horizontal], 20)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.btn_color).shadow(radius: 5)
                                        .padding([.horizontal],15))
                        
                        HStack{
                            if isValidEmailFormat && mail != "" && school != nil{
                                Image(systemName : "checkmark")
                                    .foregroundColor(.green)
                                
                                Text("감지된 학교 : \(school!)")
                                    .font(.caption)
                                    .foregroundColor(.green)
                                
                            } else if !isValidEmailFormat{
                                Image(systemName : "xmark")
                                    .foregroundColor(.red)
                                
                                Text("올바른 E-Mail 포맷을 입력해주세요.")
                                    .font(.caption)
                                    .foregroundColor(.red)
                                
                            } else if mail != "" && school == nil{
                                Image(systemName : "xmark")
                                    .foregroundColor(.red)
                                
                                Text("학교를 찾을 수 없거나 지원 대상 학교가 아닙니다.")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                            
                            Spacer()

                            
                            Button(action : {
                                showModal = true
                            }){
                                Text("지원 대상 학교 보기")
                                    .font(.caption)
                                    .foregroundColor(.accent)
                            }
                            
                        }.padding([.horizontal], 20)
                        
                        Spacer().frame(height : 20)
                        
                        if isSupportSchool{
                            HStack {
                                Image(systemName: "key.fill")
                                
                                SecureField("비밀번호", text:$password)
                            }
                            .foregroundColor(Color.txt_color)
                            .padding(20)
                            .padding([.horizontal], 20)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.btn_color).shadow(radius: 5)
                                            .padding([.horizontal],15))
                            
                            HStack {
                                Text("보안을 위해 6자 이상의 비밀번호를 설정해주세요.")
                                    .foregroundColor(.gray)
                                .font(.caption)
                                
                                Spacer()
                            }.padding([.horizontal], 20)
                            
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
                                .isHidden(self.mail.isEmpty || self.password.isEmpty || self.password_check.isEmpty || self.password.count < 6 || self.password != self.password_check || !self.mail.contains("@") || !isSupportSchool)
                            }
                        }
                    }
                }
            }
        }.animation(.easeInOut).background(Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
        .fullScreenCover(isPresented: $showProcess, content: {
            Progress_register(name: $name, nickName: $nickName, studentNo : $studentNo, phone: $phone, mail: $mail, password: $password, marketingAccept: $marketingAccept, helper: UserManagement())
        })
        .sheet(isPresented: $showModal, content: {
            SupportSchoolListView()
        })
    }
}

struct signUp_register_Previews: PreviewProvider {
    static var previews: some View {
        signUp_register(name: .constant(""), nickName: .constant(""), studentNo: .constant(""), phone: .constant(""), marketingAccept: .constant(true))
    }
}
