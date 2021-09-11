//
//  addProfile.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/13.
//

import SwiftUI

struct addProfile: View {
    @State private var profile = "pig"
    @State private var profile_bg : Color = .sozip_bg_1
    @State private var showAlert = false
    @EnvironmentObject var userManagement : UserManagement
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            ScrollView{
                
                VStack{
                    Text("고객님의 개성을 표현해보세요!")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.txt_color)
                    
                    Spacer().frame(height : 5)
                    
                    Text("채팅에서 표시될 프로필을 설정해보세요!")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer().frame(height : 40)
                    
                    switch profile{
                    case "pig" :
                        Text("🐷")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .padding(10)
                            .background(Circle().foregroundColor(profile_bg).shadow(radius: 5))
                        
                    case "rabbit" :
                        Text("🐰")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .padding(10)
                            .background(Circle().foregroundColor(profile_bg).shadow(radius: 5))
                        
                    case "tiger" :
                        Text("🐯")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .padding(10)
                            .background(Circle().foregroundColor(profile_bg).shadow(radius: 5))
                        
                    case "monkey" :
                        Text("🐵")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .padding(10)
                            .background(Circle().foregroundColor(profile_bg).shadow(radius: 5))
                        
                    case "chick" :
                        Text("🐥")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .padding(10)
                            .background(Circle().foregroundColor(profile_bg).shadow(radius: 5))
                        
                    default :
                        Text("🐷")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .padding(10)
                            .background(Circle().foregroundColor(profile_bg).shadow(radius: 5))
                    }
                    
                    Spacer().frame(height : 40)
                    
                    Group {
                        HStack{
                            Text("프로필 이미지 설정")
                                .font(.body)
                                .fontWeight(.semibold)
                                .foregroundColor(.txt_color)
                            
                            Spacer()
                        }
                        
                        Spacer().frame(height : 20)
                        
                        HStack{
                            Button(action: {
                                profile = "pig"
                            }){
                                Text("🐷")
                                    .font(.largeTitle)
                                    .fontWeight(.semibold)
                                    .padding(5)
                                    .background(Circle()
                                                    .strokeBorder(lineWidth: 3, antialiased: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                                    .isHidden(profile != "pig")
                                    )
                            }
                            
                            Spacer().frame(width : 20)
                            
                            Button(action: {
                                profile = "rabbit"
                            }){
                                Text("🐰")
                                    .font(.largeTitle)
                                    .fontWeight(.semibold)
                                    .padding(5)
                                    .background(Circle()
                                                    .strokeBorder(lineWidth: 3, antialiased: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                                    .isHidden(profile != "rabbit")
                                    )
                            }
                            
                            Spacer().frame(width : 20)
                            
                            Button(action: {
                                profile = "tiger"
                            }){
                                Text("🐯")
                                    .font(.largeTitle)
                                    .fontWeight(.semibold)
                                    .padding(5)
                                    .background(Circle()
                                                    .strokeBorder(lineWidth: 3, antialiased: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                                    .isHidden(profile != "tiger")
                                    )
                            }
                            
                            Spacer().frame(width : 20)
                            
                            Button(action: {
                                profile = "monkey"
                            }){
                                Text("🐵")
                                    .font(.largeTitle)
                                    .fontWeight(.semibold)
                                    .padding(5)
                                    .background(Circle()
                                                    .strokeBorder(lineWidth: 3, antialiased: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                                    .isHidden(profile != "monkey")
                                    )
                            }
                            
                            Spacer().frame(width : 20)
                            
                            Button(action: {
                                profile = "chick"
                            }){
                                Text("🐥")
                                    .font(.largeTitle)
                                    .fontWeight(.semibold)
                                    .padding(5)
                                    .background(Circle()
                                                    .strokeBorder(lineWidth: 3, antialiased: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                                    .isHidden(profile != "chick")
                                    )
                            }
                        }
                    }
                    
                    Spacer().frame(height : 40)
                    
                    Group {
                        HStack{
                            Text("프로필 배경 설정")
                                .font(.body)
                                .fontWeight(.semibold)
                                .foregroundColor(.txt_color)
                            
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
                        
                        Spacer().frame(height : 60)
                        
                    }
                    
                    Button(action : {
                        userManagement.setProfile(profile: profile, profile_bg: profile_bg){result in
                            guard let result = result else{return}
                            
                            if result{
                                presentationMode.wrappedValue.dismiss()
                            }
                            
                            else{
                                showAlert = true
                            }
                        }
                    }){
                        HStack{
                            Text("프로필 설정하기")
                                .foregroundColor(.white)
                            
                            Image(systemName : "chevron.right")
                                .foregroundColor(.white)
                            
                        }.frame(width : UIScreen.main.bounds.width / 1.5,
                                height : 50)
                        .background(RoundedRectangle(cornerRadius : 15)
                                        .foregroundColor(.accent)
                                        .shadow(radius : 5))
                    }
                }.padding(20)
                .alert(isPresented: $showAlert, content: {
                    Alert(title: Text("프로필 설정 실패"), message: Text("프로필을 설정하는 중 문제가 발생했습니다.\n나중에 더 보기에서 다시 시도해주세요."), dismissButton: .default(Text("확인")){self.presentationMode.wrappedValue.dismiss()})
                })
            }
        }
    }
}

struct addProfile_Previews: PreviewProvider {
    static var previews: some View {
        addProfile()
            .preferredColorScheme(.dark)
    }
}
