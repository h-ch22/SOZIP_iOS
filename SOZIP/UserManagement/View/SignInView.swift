//
//  SignInView.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/20.
//

import SwiftUI

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isEmailEditing = false
    @State private var showOverlay = false
    @State private var showAlert = false
    @State private var showHome = false
    @State private var showProcess = false
    @State private var alertModel : signInResultModel? = nil
    @ObservedObject var helper : UserManagement
    
    private let user_mail : String? = UserDefaults.standard.string(forKey: "signIn_mail")
    private let user_password : String? = UserDefaults.standard.string(forKey: "signIn_password")
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
                VStack(alignment : .center){
                    Spacer()
                    
                    Group {
                        Image("appstore")
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .shadow(radius: 5)
                        
                        HStack {
                            Text("소집")
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                .fontWeight(.bold)
                            
                            Text(": SOZIP")
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            
                        }
                    }
                    
                    Spacer().frame(height : 45)

                    Group{
                        HStack {
                            Image(systemName: "at.circle.fill")
                            
                            TextField("E-Mail", text:$email, onEditingChanged: {(editing) in
                                if editing{
                                    isEmailEditing = true
                                }
                                
                                else{
                                    isEmailEditing = false
                                }
                            })
                        }
                        .foregroundColor(isEmailEditing ? Color.accent : Color.txt_color)
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
                    }
                    
                    Spacer().frame(height : 45)
                    
                    Group{
                        Button(action: {
                            if !email.isEmpty && !password.isEmpty{
                                showProcess = true
                                
                                helper.signIn(mail : email, password: password){(result) in
                                    guard let result = result else{return}
                                    
                                    if result == "success"{
                                        showProcess = false
                                        showHome = true
                                        print("signIn success")
                                    }
                                    
                                    else{
                                        alertModel = .error
                                        
                                        showProcess = false
                                        showAlert = true
                                    }
                                }
                            }
                            
                            else{
                                alertModel = .noField
                                showAlert = true
                            }

                        }){
                            HStack{
                                Text("로그인")
                                    .foregroundColor(.white)
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                            }.padding(20)
                            .padding([.horizontal], 100)
                            .background(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).shadow(radius: 5).foregroundColor(self.email.isEmpty || self.password.isEmpty ? .gray : .accent))
                            .disabled(self.email.isEmpty || self.password.isEmpty)
                        }
                        
                        Spacer().frame(height : 45)

                        NavigationLink(destination: SignUpView()){
                            HStack {
                                VStack(alignment:.leading){
                                    Text("처음 사용하시나요?")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    
                                    Text("학생증 인증 바로가기")
                                        .foregroundColor(.white)
                                        .font(.caption)
                                }
                                
                                Spacer().frame(width : 90)
                                
                                Image(systemName: "arrow.forward.circle.fill")
                                    .resizable()
                                    .frame(width : 30, height : 30)
                                    .foregroundColor(.white)
                                    
                            }.padding(20)
                            .background(RoundedRectangle(cornerRadius: 15)
                                            .foregroundColor(.accent)
                                            .shadow(radius: 5))
                        }
                    }
                    
                    Spacer().frame(height : 20)
                    
                    Group {
                        Text("© 2021. eje All Rights Reserved.")
                            .foregroundColor(.gray)
                            .font(.caption)
                        
                        Spacer().frame(height : 5)
                        
                        Text("이제이 | 대표 : 문소정 | 사업자등록번호 : 763-33-00865")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: true, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    }
                    
                    Spacer()
                }

            }.navigationBarHidden(true)
            
            .alert(isPresented : $showAlert){
                    switch alertModel{
                    case .noNetwork:
                        return Alert(title: Text("네트워크 연결 오류"),
                                     message: Text("네트워크에 연결되어 있지 않습니다.\n네트워크 상태를 확인해주세요."),
                                     dismissButton: .default(Text("확인")))
                        
                    case .error:
                        return Alert(title: Text("로그인 실패"),
                                     message: Text("로그인 중 오류가 발생했습니다.\n입력한 정보를 확인한 후 다시 시도해주십시오."),
                                     dismissButton: .default(Text("확인")))
                        
                    case .noField:
                        return Alert(title: Text("공백 필드"),
                                     message : Text("모든 필드를 채워주세요."),
                                     dismissButton: .default(Text("확인")))
                        
                    case .success:
                        break
                        
                    case .disabled:
                        return Alert(title: Text("제한된 계정"),
                                     message : Text("이 계정으로 로그인이 허가되지 않았습니다."),
                                     dismissButton: .default(Text("확인")))
                        
                    case .fail:
                        return Alert(title: Text("로그인 실패"),
                                     message: Text("로그인 중 오류가 발생했습니다.\n입력한 정보를 확인한 후 다시 시도해주십시오."),
                                     dismissButton: .default(Text("확인")))
                    case .none:
                        break
                    }
                
                return Alert(title: Text(""), message: Text(""), dismissButton: .default(Text("")))
                }
            
            .fullScreenCover(isPresented: $showHome, content: {
                TabManager(chatHelper: ChatHelper(), helper : SOZIPHelper())
            })
            
            .overlay(
                ProcessView()
                    .isHidden(!showProcess)
            )
            
            .onAppear(perform: {
                if user_mail != nil && user_password != nil{
                    showProcess = true
                    
                    helper.signIn(mail : email, password: password){(result) in
                        guard let result = result else{return}
                        
                        if result == "success"{
                            showProcess = false
                            showHome = true
                            print("signIn success")
                        }
                        
                        else{
                            alertModel = .error
                            
                            showProcess = false
                            showAlert = true
                        }
                    }
                }
            })
            
            
            
        }.accentColor(.accent)
        
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(helper : UserManagement())
    }
}
