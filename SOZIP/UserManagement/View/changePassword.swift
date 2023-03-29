//
//  changePassword.swift
//  SOZIP
//
//  Created by 하창진 on 2021/09/06.
//

import SwiftUI
import Firebase

struct changePassword: View {
    @State private var password = ""
    @State private var checkPassword = ""
    @State private var current_Password = ""
    
    @State private var showAlert = false
    @State private var showSignIn = false
    @State private var showOverlay = false
    @State private var AlertType : changePasswordAlertModel? = nil
    
    @StateObject var userManagement = UserManagement()
    
    var body: some View {
        ScrollView{
            ZStack {
                Color.backgroundColor.edgesIgnoringSafeArea(.all)
                
                VStack{
                    Image(systemName: "lock.circle.fill")
                        .resizable()
                        .frame(width : 100, height : 100)
                        .foregroundColor(.btn_dark)
                    
                    Spacer().frame(height : 10)
                    
                    Text("\(Auth.auth().currentUser?.email ?? "")\n계정의 비밀번호를 변경합니다.")
                        .fontWeight(.semibold)
                        .foregroundColor(.txt_color)
                        .multilineTextAlignment(.center)
                    
                    Spacer().frame(height : 10)
                    
                    Text("계속 하려면 현재 비밀번호를 입력하고 진행하십시오.")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer().frame(height : 20)
                    
                    Group{
                        HStack {
                            Image(systemName: "key.fill")
                            
                            SecureField("현재 비밀번호", text:$current_Password)
                        }
                        .foregroundColor(Color.txt_color)
                        .padding(20)
                        .padding([.horizontal], 20)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.btn_color).shadow(radius: 5)
                            .padding([.horizontal],15))
                        
                        Spacer().frame(height : 20)
                        
                        HStack {
                            Image(systemName: "key.fill")
                            
                            SecureField("새 비밀번호", text:$password)
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
                            
                            SecureField("한번 더", text:$checkPassword)
                        }
                        .foregroundColor(Color.txt_color)
                        .padding(20)
                        .padding([.horizontal], 20)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.btn_color).shadow(radius: 5)
                            .padding([.horizontal],15))
                        
                        Spacer().frame(height : 20)
                        
                        Text("비밀번호 변경 시 기기에서 로그아웃 됩니다.")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        if self.password != "" && self.checkPassword != "" && self.current_Password != ""{
                            Button(action: {
                                if password != checkPassword{
                                    AlertType = .noMatch
                                    showAlert = true
                                }
                                
                                else if password.count < 6{
                                    AlertType = .limit
                                    showAlert = true
                                }
                                
                                else{
                                    AlertType = .confirm
                                    showAlert = true
                                }
                            }){
                                HStack{
                                    Text("비밀번호 변경")
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
                    
                }.padding(20)
            }
        }.background(Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
            .navigationBarTitle("비밀번호 변경", displayMode: .large)
        
            .fullScreenCover(isPresented: $showSignIn, content: {
                SignInView(helper: UserManagement())
            })
        
            .overlay(ProcessView().isHidden(!showOverlay))
        
            .alert(isPresented : $showAlert){
                switch AlertType{
                case .confirm :
                    return Alert(title: Text("비밀번호 변경"),
                                 message: Text("비밀번호를 변경하시겠습니까?\n비밀번호 변경 시 다시 로그인하셔야 합니다."),
                                 primaryButton: .default(Text("예")){
                        showOverlay = true
                        
                        if Auth.auth().currentUser == nil{
                            showOverlay = false
                            AlertType = .noUser
                            showAlert = true
                        }
                        
                        else{
                            Auth.auth().signIn(withEmail: Auth.auth().currentUser?.email ?? "", password: current_Password){authResult, error in
                                if let error = error{
                                    print(error)
                                    let errorCode = error as NSError
                                    
                                    switch errorCode.code{
                                    case AuthErrorCode.wrongPassword.rawValue:
                                        showOverlay = false
                                        AlertType = .noMatchPW
                                        showAlert = true
                                        
                                    case AuthErrorCode.invalidEmail.rawValue:
                                        showOverlay = false
                                        AlertType = .invalidEmail
                                        showAlert = true
                                        
                                    case AuthErrorCode.networkError.rawValue:
                                        showOverlay = false
                                        AlertType = .networkError
                                        showAlert = true
                                        
                                    case AuthErrorCode.invalidUserToken.rawValue:
                                        showOverlay = false
                                        AlertType = .invalidEmail
                                        showAlert = true
                                        
                                    case AuthErrorCode.userTokenExpired.rawValue:
                                        showOverlay = false
                                        AlertType = .invalidEmail
                                        showAlert = true
                                        
                                    default:
                                        showOverlay = false
                                        AlertType = .error
                                        showAlert = true
                                    }
                                    
                                    
                                }
                                
                                else{
                                    userManagement.updatePassword(password: password){result in
                                        guard let result = result else{return}
                                        
                                        showOverlay = false
                                        
                                        if result == "success"{
                                            AlertType = .done
                                            showAlert = true
                                        }
                                        
                                        else if result == "noUser"{
                                            AlertType = .noUser
                                            showAlert = true
                                        }
                                        
                                        else{
                                            AlertType = .error
                                            showAlert = true
                                        }
                                    }
                                }
                            }
                        }
                        
                        
                    },
                                 secondaryButton: .default(Text("아니오")))
                case .none:
                    return Alert(title: Text(""), message: Text(""), dismissButton: .default(Text("")))
                    
                case .some(.limit):
                    return Alert(title: Text("비밀번호 제한"),
                                 message: Text("보안을 위해 6자리 이상의 비밀번호를 입력해주세요."),
                                 dismissButton: .default(Text("확인")){
                        self.password = ""
                        self.checkPassword = ""
                    })
                case .some(.done):
                    return Alert(title: Text("비밀번호 변경 완료"),
                                 message: Text("비밀번호가 변경되었습니다."),
                                 dismissButton: .default(Text("확인")){
                        userManagement.signOut(){result in
                            guard let result = result else{return}
                            
                            
                        }
                        
                        showSignIn = true
                    })
                    
                case .some(.error):
                    return Alert(title: Text("오류"),
                                 message: Text("비밀번호를 변경하는 중 오류가 발생했습니다.\n네트워크 상태를 확인하거나 나중에 다시 시도하십시오."),
                                 dismissButton: .default(Text("확인")){
                        
                    })
                    
                case .some(.noUser):
                    return Alert(title: Text("사용자 정보 없음"),
                                 message: Text("사용자 정보가 없습니다.\n확인 버튼을 누르면 로그인 페이지로 이동합니다."),
                                 dismissButton: .default(Text("확인")){
                        showSignIn = true
                    })
                    
                case .some(.noMatch):
                    return Alert(title: Text("비밀번호 불일치"),
                                 message: Text("새로운 비밀번호와 비밀번호 확인이 일치하지 않습니다."),
                                 dismissButton: .default(Text("확인")){
                        self.password = ""
                        self.checkPassword = ""
                    })
                    
                case .some(.noMatchPW):
                    return Alert(title: Text("비밀번호 불일치"),
                                 message: Text("현재 비밀번호가 일치하지 않습니다."),
                                 dismissButton: .default(Text("확인")){
                        self.current_Password = ""
                    })
                case .some(.invalidEmail):
                    return Alert(title: Text("유효하지 않은 계정"),
                                 message: Text("이 계정은 유효하지 않습니다.\n다시 로그인해주세요."),
                                 dismissButton: .default(Text("확인")){
                        self.showSignIn = true
                    })
                case .some(.networkError):
                    return Alert(title: Text("네트워크 오류"),
                                 message: Text("네트워크에 연결되어 있지 않거나, 연결이 불안정합니다."),
                                 dismissButton: .default(Text("확인")){
                        self.current_Password = ""
                    })
                }
            }
    }
}

struct changePassword_Previews: PreviewProvider {
    static var previews: some View {
        changePassword()
    }
}
