//
//  MoreView.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/28.
//

import SwiftUI

struct MoreView: View {
    @EnvironmentObject var helper : UserManagement
    @State private var showAlert = false
    @State private var alertModel : More_AlertModel?
    @State private var showSignInScreen = false
    
    var body: some View {
        NavigationView{
            ZStack {
                Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
                VStack{
                    HStack{
                        Text("소집 : SOZIP")
                            .fontWeight(.bold)
                        
                        Spacer()
                    }
                    
                    Spacer().frame(height : 20)

                    HStack{
                        NavigationLink(destination : editProfileView()){
                            HStack {
                                Image("profile_burger")
                                    .resizable()
                                    .frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                
                                Text(helper.nickName)
                                    .foregroundColor(.txt_color)
                                    .fontWeight(.bold)
                                
                                Spacer()
                                
                            }.padding(20)
                            .padding([.vertical], 10)
                            .background(RoundedRectangle(cornerRadius: 15)
                                            .foregroundColor(.btn_color)
                                            .shadow(radius: 2, x:0, y:2))
                        }
                    }
                    
                    Spacer().frame(height : 20)

                    Divider()
                    
                    ScrollView{
                        VStack{
                            Group{
                                Spacer().frame(height : 20)

                                NavigationLink(destination : NoticeView()){
                                    HStack{
                                        Image("ic_notice")
                                            .resizable()
                                            .frame(width: 30, height: 30, alignment: .leading)
                                        
                                        Text("공지사항")
                                            .foregroundColor(.txt_color)
                                            .fontWeight(.semibold)
                                        
                                        Spacer()
                                    }.padding(20)
                                    .padding([.vertical], 10)
                                    .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btn_color).shadow(radius: 2, x:0, y:2))
                                }
                                
                                Spacer().frame(height : 20)

                                NavigationLink(destination : LogView(helper : SOZIPHelper())){
                                    HStack{
                                        Image("ic_log")
                                            .resizable()
                                            .frame(width: 30, height: 30, alignment: .leading)
                                        
                                        Text("이용 기록")
                                            .foregroundColor(.txt_color)
                                            .fontWeight(.semibold)
                                        
                                        Spacer()
                                    }.padding(20)
                                    .padding([.vertical], 10)
                                    .background(RoundedRectangle(cornerRadius: 15)
                                                    .foregroundColor(.btn_color)
                                                    .shadow(radius: 2, x:0, y:2))
                                }
                                
                                Spacer().frame(height : 20)
                                
                                NavigationLink(destination : FeedbackHubMain(helper: FeedbackHubHelper())){
                                    HStack{
                                        Image("ic_feedbackHub")
                                            .resizable()
                                            .frame(width: 30, height: 30, alignment: .leading)
                                        
                                        Text("피드백 허브")
                                            .foregroundColor(.txt_color)
                                            .fontWeight(.semibold)
                                        
                                        Spacer()
                                    }.padding(20)
                                    .padding([.vertical], 10)
                                    .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btn_color).shadow(radius: 2, x:0, y:2))
                                }
                            }
                            
                            Group{
                                Spacer().frame(height : 20)

                                Button(action: {
                                    self.alertModel = .signOut
                                }){
                                    HStack{
                                        Image("ic_signOut")
                                            .resizable()
                                            .frame(width: 30, height: 30, alignment: .leading)
                                        
                                        Text("로그아웃")
                                            .foregroundColor(.txt_color)
                                            .fontWeight(.semibold)
                                        
                                        Spacer()
                                    }.padding(20)
                                    .padding([.vertical], 10)
                                    .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btn_color).shadow(radius: 2, x:0, y:2))
                                }
                                
                                Spacer().frame(height : 20)

                                Button(action: {
                                    self.alertModel = .secession
                                }){
                                    HStack{
                                        Image("ic_secession")
                                            .resizable()
                                            .frame(width: 30, height: 30, alignment: .leading)
                                        
                                        Text("회원 탈퇴")
                                            .foregroundColor(.txt_color)
                                            .fontWeight(.semibold)
                                        
                                        Spacer()
                                    }.padding(20)
                                    .padding([.vertical], 10)
                                    .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btn_color).shadow(radius: 2, x:0, y:2))
                                }
                                
                                Spacer().frame(height : 20)

                                NavigationLink(destination: InfoView(helper : VersionManager())){
                                    HStack{
                                        Image("ic_info")
                                            .resizable()
                                            .frame(width: 30, height: 30, alignment: .leading)
                                            .foregroundColor(.btn_dark)
                                        
                                        Text("정보")
                                            .foregroundColor(.txt_color)
                                            .fontWeight(.semibold)
                                        
                                        Spacer()
                                    }.padding(20)
                                    .padding([.vertical], 10)
                                    .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btn_color).shadow(radius: 2, x:0, y:2))
                                }
                            }
                        }
                    }
                    
                }.padding([.horizontal], 20)
                .navigationBarHidden(true)
                .fullScreenCover(isPresented: $showSignInScreen, content: {
                    SignInView(helper : UserManagement())
                })
                
                .alert(item: $alertModel){item in
                    switch(item){
                    case .signOut:
                        return Alert(title: Text("로그아웃"),
                                     message: Text("로그아웃 시 자동 로그인이 해제되며, 다시 로그인하셔야 합니다.\n계속 하시겠습니까?"),
                                     primaryButton: .default(Text("예")){
                                        helper.signOut(){result in
                                            guard let result = result else{return}
                                            
                                            if result{
                                                self.showSignInScreen = true
                                            }
                                            
                                            else{
                                                alertModel = .signOutFail
                                            }
                                        }
                                     }, secondaryButton: .default(Text("아니오")))
                        
                    case .secession:
                        return Alert(title: Text("회원 탈퇴 안내"),
                                     message: Text("회원 탈퇴 시 모든 정보가 제거되며, 복구할 수 없습니다.\n계속 하시겠습니까?"),
                                     primaryButton: .default(Text("예")){
                                        helper.secession(){result in
                                            guard let result = result else{return}
                                            
                                            if result == "success"{
                                                alertModel = .greet
                                            }
                                            
                                            else if result == "noUser"{
                                                alertModel = .noUser
                                            }
                                            
                                            else{
                                                alertModel = .secessionFail
                                            }
                                        }
                                     },
                                     secondaryButton: .default(Text("아니오")){
                                        
                                     })
                    case .greet:
                        return Alert(title: Text("감사 인사"),
                                     message: Text("회원 탈퇴가 완료되었습니다.\n더 나은 서비스로 다시 만날 수 있도록 노력하겠습니다.\n그 동안 서비스를 이용해주셔서 감사합니다."),
                                     dismissButton: .default(Text("확인")){
                                        self.showSignInScreen = true
                                     })
                        
                    case .secessionFail:
                        return Alert(title: Text("오류"), message: Text("회원 탈퇴 처리 중 오류가 발생했습니다.\n네트워크 상태를 확인하거나 나중에 다시 시도하십시오."), dismissButton: .default(Text("확인")))
                        
                    case .noUser:
                        return Alert(title: Text("사용자 정보 없음"),
                                     message: Text("사용자 정보가 없습니다.\n로그인 화면으로 이동합니다."),
                                     dismissButton: .default(Text("확인")){self.showSignInScreen = true})
                        
                    case .signOutFail:
                        return Alert(title: Text("오류"), message: Text("로그아웃 처리 중 오류가 발생했습니다.\n네트워크 상태를 확인하거나 나중에 다시 시도하십시오."), dismissButton: .default(Text("확인")){self.showSignInScreen = true})
                    }
                }
            }
        }.accentColor(.accent)
        
    }
}

struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
        MoreView().environmentObject(UserManagement())
    }
}
