//
//  editProfile.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/11.
//

import SwiftUI

struct editProfileView: View {
    @State private var nickName = ""
    @State private var isNickNameEditing = false
    
    @State private var showAlert = false
    @State private var alertModel : More_AlertModel?
    @State private var showSignInScreen = false
    
    @State private var profile = ""
    @State private var profile_bg : Color = .sozip_bg_1
    
    @State private var showProcess = false
    
    @EnvironmentObject var helper : UserManagement
    
    var body: some View {
        ZStack{
            Color.backgroundColor.edgesIgnoringSafeArea(.all)
            
            ScrollView{
                
                VStack{
                    Group {
                        Spacer().frame(height : 15)
                        
                        Text(profile)
                            .font(.system(size: 50, weight: .semibold))
                            .background(Circle()
                                .foregroundColor(profile_bg)
                                .frame(width : 100, height : 100)
                                .shadow(color: .gray, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/))
                        
                        Spacer().frame(height : 30)
                        
                        Text(helper.name)
                            .fontWeight(.semibold)
                            .foregroundColor(.txt_color)
                        
                        Spacer().frame(height : 20)
                        
                        HStack{
                            Text("닉네임 변경")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Spacer()
                        }
                        
                        Spacer().frame(height : 10)
                        
                        HStack {
                            Image(systemName: "person.fill")
                            
                            TextField("닉네임", text:$nickName, onEditingChanged: {(editing) in
                                if editing{
                                    isNickNameEditing = true
                                }
                                
                                
                                else{
                                    isNickNameEditing = false
                                }
                                
                            })
                        }
                        .foregroundColor(isNickNameEditing ? Color.accent : Color.txt_color)
                        .padding(20)
                        .padding([.horizontal], 20)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.btn_color).shadow(radius: 5)
                            .padding([.horizontal],15))
                        
                        Spacer().frame(height : 20)
                        
                        HStack{
                            Text("프로필 이미지 설정")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Spacer()
                        }
                    }
                    
                    Spacer().frame(height : 10)
                    
                    Group {
                        Spacer().frame(height : 20)
                        
                        HStack{
                            Button(action: {
                                profile = "🐷"
                            }){
                                Text("🐷")
                                    .font(.largeTitle)
                                    .fontWeight(.semibold)
                                    .padding(5)
                                    .background(Circle()
                                        .strokeBorder(lineWidth: 3, antialiased: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                        .isHidden(profile != "pig" && profile != "🐷")
                                    )
                            }
                            
                            Spacer().frame(width : 20)
                            
                            Button(action: {
                                profile = "🐰"
                            }){
                                Text("🐰")
                                    .font(.largeTitle)
                                    .fontWeight(.semibold)
                                    .padding(5)
                                    .background(Circle()
                                        .strokeBorder(lineWidth: 3, antialiased: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                        .isHidden(profile != "rabbit" && profile != "🐰")
                                    )
                            }
                            
                            Spacer().frame(width : 20)
                            
                            Button(action: {
                                profile = "🐯"
                            }){
                                Text("🐯")
                                    .font(.largeTitle)
                                    .fontWeight(.semibold)
                                    .padding(5)
                                    .background(Circle()
                                        .strokeBorder(lineWidth: 3, antialiased: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                        .isHidden(profile != "tiger" && profile != "🐯")
                                    )
                            }
                            
                            Spacer().frame(width : 20)
                            
                            Button(action: {
                                profile = "🐵"
                            }){
                                Text("🐵")
                                    .font(.largeTitle)
                                    .fontWeight(.semibold)
                                    .padding(5)
                                    .background(Circle()
                                        .strokeBorder(lineWidth: 3, antialiased: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                        .isHidden(profile != "monkey" && profile != "🐵")
                                    )
                            }
                            
                            Spacer().frame(width : 20)
                            
                            Button(action: {
                                profile = "🐥"
                            }){
                                Text("🐥")
                                    .font(.largeTitle)
                                    .fontWeight(.semibold)
                                    .padding(5)
                                    .background(Circle()
                                        .strokeBorder(lineWidth: 3, antialiased: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                        .isHidden(profile != "chick" && profile != "🐥")
                                    )
                            }
                        }
                    }
                    
                    Spacer().frame(height : 40)
                    
                    Group {
                        HStack{
                            Text("프로필 배경 설정")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Spacer()
                        }
                        
                        Spacer().frame(height : 20)
                        
                        HStack{
                            Button(action: {
                                profile_bg = .sozip_bg_1
                            }){
                                Circle()
                                    .frame(width : 40, height : 40)
                                    .foregroundColor(.sozip_bg_1)
                                    .shadow(radius: 5)
                                    .overlay(Image(systemName : "checkmark")
                                        .foregroundColor(.white)
                                        .isHidden(profile_bg != .sozip_bg_1)
                                    )
                            }
                            
                            Spacer().frame(width : 40)
                            
                            Button(action: {
                                profile_bg = .sozip_bg_2
                            }){
                                Circle()
                                    .frame(width : 40, height : 40)
                                    .foregroundColor(.sozip_bg_2)
                                    .shadow(radius: 5)
                                    .overlay(Image(systemName : "checkmark")
                                        .foregroundColor(.white)
                                        .isHidden(profile_bg != .sozip_bg_2)
                                    )
                            }
                            
                            Spacer().frame(width : 40)
                            
                            Button(action: {
                                profile_bg = .sozip_bg_3
                            }){
                                Circle()
                                    .frame(width : 40, height : 40)
                                    .foregroundColor(.sozip_bg_3)
                                    .shadow(radius: 5)
                                    .overlay(Image(systemName : "checkmark")
                                        .foregroundColor(.white)
                                        .isHidden(profile_bg != .sozip_bg_3)
                                    )
                            }
                            
                            Spacer().frame(width : 40)
                            
                            Button(action: {
                                profile_bg = .sozip_bg_4
                            }){
                                Circle()
                                    .frame(width : 40, height : 40)
                                    .foregroundColor(.sozip_bg_4)
                                    .shadow(radius: 5)
                                    .overlay(Image(systemName : "checkmark")
                                        .foregroundColor(.white)
                                        .isHidden(profile_bg != .sozip_bg_4)
                                    )
                            }
                            
                            Spacer().frame(width : 40)
                            
                            Button(action: {
                                profile_bg = .sozip_bg_5
                            }){
                                Circle()
                                    .frame(width : 40, height : 40)
                                    .foregroundColor(.sozip_bg_5)
                                    .shadow(radius: 5)
                                    .overlay(Image(systemName : "checkmark")
                                        .foregroundColor(.white)
                                        .isHidden(profile_bg != .sozip_bg_5)
                                    )
                            }
                            
                        }
                    }
                    
                    Spacer().frame(height : 20)
                    
                    Group{
                        HStack{
                            Text("개인 정보 관리")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Spacer()
                        }
                        
                        NavigationLink(destination : changePassword()){
                            HStack{
                                Image(systemName : "key.viewfinder")
                                    .resizable()
                                    .frame(width : 30, height : 30)
                                    .foregroundColor(.txt_color)
                                
                                Text("비밀번호 변경")
                                    .foregroundColor(.txt_color)
                                
                                Spacer()
                            }.padding(20)        .background(RoundedRectangle(cornerRadius: 15.0)
                                .shadow(radius: 2, x: 0, y: 2)
                                .foregroundColor(.btn_color))
                        }
                        
                        NavigationLink(destination : changeUserInfo()){
                            HStack{
                                Image(systemName : "phone.circle.fill")
                                    .resizable()
                                    .frame(width : 30, height : 30)
                                    .foregroundColor(.txt_color)
                                
                                Text("연락처 변경")
                                    .foregroundColor(.txt_color)
                                
                                Spacer()

                            }.padding(20).background(RoundedRectangle(cornerRadius: 15.0)
                                .shadow(radius: 2, x: 0, y: 2)
                                .foregroundColor(.btn_color))
                            
                        }
                        
                        NavigationLink(destination : ManageAccountView()){
                            HStack{
                                Image(systemName : "wonsign.circle.fill")
                                    .resizable()
                                    .frame(width : 30, height : 30)
                                    .foregroundColor(.txt_color)
                                
                                Text("계좌 관리")
                                    .foregroundColor(.txt_color)
                                
                                Spacer()

                            }.padding(20).background(RoundedRectangle(cornerRadius: 15.0)
                                .shadow(radius: 2, x: 0, y: 2)
                                .foregroundColor(.btn_color))
                            
                        }
                        
                        Spacer().frame(height : 20)
                        
                        Button(action: {
                            showProcess = true
                            
                            helper.updateProfile(nickName: nickName, bg: profile_bg, profile: profile){result in
                                guard let result = result else{return}
                                
                                if result{
                                    showProcess = false
                                    
                                    alertModel = .updateSuccess
                                    showAlert = true
                                }
                                
                                else{
                                    showProcess = false
                                    
                                    alertModel = .updateFail
                                    showAlert = true
                                }
                            }
                        }){
                            HStack{
                                Text("프로필 변경하기")
                                    .foregroundColor(.white)
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                            }.padding(20)
                                .frame(width : 300)
                                .background(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).shadow(radius: 5))
                                .isHidden(self.nickName == helper.nickName && helper.profile == self.profile && helper.getColor() == self.profile_bg)
                        }
                        
                        HStack {
                            Button(action : {
                                alertModel = .signOut
                                showAlert = true
                            }){
                                Text("로그아웃")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .underline(true, color : .gray)
                            }
                            
                            Text("또는")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Button(action : {
                                alertModel = .secession
                                showAlert = true
                            }){
                                Text("회원 탈퇴")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .underline(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, color: .gray)
                            }
                        }
                    }
                    
                    
                }.padding(20)
                    .onAppear(perform: {
                        nickName = helper.nickName
                        profile = helper.getProfile()
                        profile_bg = helper.getColor()
                    })
                
                    .navigationBarTitle("프로필 정보 변경", displayMode: .inline)
                
                    .fullScreenCover(isPresented: $showSignInScreen, content: {
                        SignInView(helper : UserManagement())
                    })
                
                    .overlay(ProcessView().isHidden(!showProcess))
                
                    .alert(item: $alertModel){item in
                        switch(item){
                        case .signOut:
                            return Alert(title: Text("로그아웃"),
                                         message: Text("로그아웃 시 자동 로그인이 해제되며, 다시 로그인하셔야 합니다.\n계속 하시겠습니까?"),
                                         primaryButton: .default(Text("예")){
                                showProcess = true
                                
                                helper.signOut(){result in
                                    guard let result = result else{return}
                                    
                                    if result{
                                        showProcess = false
                                        
                                        self.showSignInScreen = true
                                    }
                                    
                                    else{
                                        showProcess = false
                                        
                                        alertModel = .signOutFail
                                    }
                                }
                            }, secondaryButton: .default(Text("아니오")))
                            
                        case .secession:
                            return Alert(title: Text("회원 탈퇴 안내"),
                                         message: Text("회원 탈퇴 시 모든 가입 정보가 제거되며, 복구할 수 없습니다.\n계속 하시겠습니까?"),
                                         primaryButton: .default(Text("예")){
                                showProcess = true
                                
                                helper.secession(){result in
                                    guard let result = result else{return}
                                    
                                    if result == "success"{
                                        showProcess = false
                                        
                                        alertModel = .greet
                                    }
                                    
                                    else if result == "noUser"{
                                        showProcess = false
                                        
                                        alertModel = .noUser
                                    }
                                    
                                    else{
                                        showProcess = false
                                        
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
                                showProcess = false
                                
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
                            
                        case .updateSuccess:
                            return Alert(title: Text("프로필 변경 완료"), message: Text("프로필이 변경되었어요!"), dismissButton: .default(Text("확인")))
                            
                        case .updateFail:
                            return Alert(title: Text("프로필 변경 오류"), message: Text("요청 사항을 처리하는 중 문제가 발생했습니다.\n네트워크 상태를 확인하거나 나중에 다시 시도해주세요."), dismissButton: .default(Text("확인")))
                        }
                    }
            }

        }
    }
}

struct editProfile_Previews: PreviewProvider {
    static var previews: some View {
        editProfileView()
    }
}
