//
//  editProfileView.swift
//  editProfileView
//
//  Created by 하창진 on 2021/08/06.
//

import SwiftUI
import Firebase

struct ProfileView: View {
    @EnvironmentObject var helper : UserManagement
    let model : [ProfileListModel] = [ProfileListModel(name: "닉네임, 프로필, 전화번호 또는 비밀번호 변경"),
                                      ProfileListModel(name : "이용 기록")]
    
    var body: some View {
        ZStack {
            Color.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer().frame(height : 15)
                
                Text(helper.getProfile())
                    .font(.system(size: 50, weight: .semibold))
                    .background(Circle().foregroundColor(helper.getColor()).frame(width : 100, height : 100).shadow(color: .gray, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/))
                
                Spacer().frame(height : 30)
                
                Text(helper.name)
                    .fontWeight(.semibold)
                    .foregroundColor(.txt_color)
                
                Spacer().frame(height : 5)
                
                Text(Auth.auth().currentUser?.email ?? "")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer().frame(height : 40)
                
                NavigationLink(destination : editProfileView().environmentObject(UserManagement())){
                    HStack{
                        Text(helper.getProfile())
                            .font(.system(size: 20, weight: .semibold))
                            .background(Circle().foregroundColor(helper.getColor()).frame(width : 40, height : 40))
                        
                        Spacer().frame(width : 15)
                        
                        Text("프로필 정보 변경")
                            .foregroundColor(.txt_color)
                        
                        Spacer()
                    }.padding(20)
                    .background(RoundedRectangle(cornerRadius: 15.0)
                    .shadow(radius: 2, x: 0, y: 2)
                    .foregroundColor(.btn_color))
                }
                
                NavigationLink(destination : LogView(helper: SOZIPHelper())){
                    HStack{
                        Image(systemName: "clock.arrow.circlepath")
                            .resizable()
                            .frame(width : 32, height : 30)
                            .foregroundColor(.txt_color)
                        
                        Spacer().frame(width : 10)
                        
                        Text("이용 기록 보기")
                            .foregroundColor(.txt_color)
                        
                        Spacer()
                    }.padding(20)
                    .background(RoundedRectangle(cornerRadius: 15.0)
                    .shadow(radius: 2, x: 0, y: 2)
                    .foregroundColor(.btn_color))
                }
                
                
            }.padding(20)
                .navigationBarTitle(Text("프로필 보기"), displayMode: .inline)
        }
        
    }
}

struct editProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView().environmentObject(UserManagement())
    }
}
