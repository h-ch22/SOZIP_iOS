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
                
                List{
                    NavigationLink(destination : editProfileView().environmentObject(UserManagement())){
                        Text("프로필 정보 변경")
                    }
                    
                    NavigationLink(destination : LogView(helper: SOZIPHelper())){
                        Text("이용 기록 보기")
                    }
                    
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
