//
//  MoreView.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/28.
//

import SwiftUI

struct MoreView: View {
    @EnvironmentObject var helper : UserManagement
    @State private var showSignInScreen = false
    
    var body: some View {
        VStack{
            HStack{
                Text("소집 : SOZIP")
                    .fontWeight(.bold)
                
                Spacer()
            }.padding(20)
            
            Spacer().frame(height : 20)

            HStack{
                NavigationLink(destination : ProfileView().environmentObject(UserManagement())){
                    HStack {
                        Text(helper.getProfile())
                            .font(.title)
                            .fontWeight(.semibold)
                            .background(Circle().foregroundColor(helper.getColor()).frame(width : 40, height : 40))
                        
                        Spacer().frame(width : 15)

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
            }.padding([.horizontal], 20)
            
            Spacer().frame(height : 20)

            Divider()
            
            ScrollView{
                VStack{
                    Group{
                        Spacer().frame(height : 20)

                        NavigationLink(destination : NoticeListView(helper : NoticeHelper())){
                            HStack{
                                Image("ic_notice")
                                    .resizable()
                                    .frame(width: 30, height: 30, alignment: .leading)
                                
                                Text("공지사항")
                                    .foregroundColor(.txt_color)
                                    .fontWeight(.semibold)
                                
                                Spacer()
                            }.padding(20)
                            .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btn_color).shadow(radius: 2, x:0, y:2))
                        }.padding([.horizontal], 20)
                        
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
                            .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btn_color).shadow(radius: 2, x:0, y:2))
                        }.padding([.horizontal], 20)
                        
                        Spacer().frame(height : 20)

                        NavigationLink(destination : CounselorView_main()){
                            HStack{
                                Image("ic_counselor")
                                    .resizable()
                                    .frame(width: 30, height: 30, alignment: .leading)
                                
                                Text("소집 문의")
                                    .foregroundColor(.txt_color)
                                    .fontWeight(.semibold)
                                
                                Spacer()
                            }.padding(20)
                            .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btn_color).shadow(radius: 2, x:0, y:2))
                        }.padding([.horizontal], 20)
                    }
                    
                    Group{
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
                            .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btn_color).shadow(radius: 2, x:0, y:2))
                        }.padding([.horizontal], 20)
                        
                        Spacer().frame(height : 20)

                        Ad_BannerViewController().frame(height: 50, alignment: .leading)

                    }
                }
            }
            
        }
        .navigationBarHidden(true)
        .animation(.easeOut)

    }
}

struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
        MoreView().environmentObject(UserManagement())
    }
}
