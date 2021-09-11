//
//  CounselorView_main.swift
//  SOZIP
//
//  Created by 하창진 on 2021/09/10.
//

import SwiftUI

struct CounselorView_main: View {
    @State private var isAdmin = false
    @StateObject private var userManagement = UserManagement()
    
    var body: some View {
        ScrollView{
            ZStack {
                Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
                VStack{
                    Group {
                        Spacer().frame(height : 20)
                        
                        Image("ic_counselor")
                            .resizable()
                            .frame(width : 150, height : 150)
                        
                        Spacer().frame(height : 10)

                        Text("소집 관련 문의가 있나요?")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.txt_color)
                        
                        Spacer().frame(height : 10)

                        Text("아래 버튼을 눌러 채팅 상담을 시작해보세요!")
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.txt_color)
                        
                        Spacer().frame(height : 40)
                    }

                    HStack{
                        Image("ic_reply")
                            .resizable()
                            .frame(width : 60, height : 60)
                        
                        Spacer().frame(width : 20)
                        
                        VStack{
                            HStack {
                                Text("답장이 조금 느릴 수 있어요!")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.txt_color)
                                
                                Spacer()
                            }
                            
                            Spacer().frame(height : 10)

                            HStack {
                                Text("최대한 빠르게 답장해드리기 위해 최선을 다하고 있어요.\n상담이 많거나, 늦은 시간인 경우 답장이 늦어질 수 있어요!")
                                    .font(.caption)
                                    .foregroundColor(.txt_color)
                                    .multilineTextAlignment(.leading)
                                    .fixedSize(horizontal: false, vertical: true)
                                
                                Spacer()
                                
                            }
                        }
                        

                        Spacer()

                    }
                    
                    Spacer().frame(height : 40)

                    if !isAdmin{
                        NavigationLink(destination: CounselorView_selectSOZIP(helper: SOZIPHelper())){
                            HStack{
                                Text("시작하기")
                                    .foregroundColor(.white)
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                            }.padding(20)
                            .padding([.horizontal], 100)
                            .background(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).shadow(radius: 5).foregroundColor(.accent))
                        }
                        
                        Spacer().frame(height : 20)

                        NavigationLink(destination: CounselorView_log()){
                            HStack{
                                Text("진행 중인 상담 목록 보기")
                                    .foregroundColor(.accent)
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.accent)
                            }
                        }
                    }
                    
                    else{
                        NavigationLink(destination: CounselorView_list()){
                            HStack{
                                Text("상담 요청 목록 보기")
                                    .foregroundColor(.white)
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                            }.padding(20)
                            .padding([.horizontal], 60)
                            .background(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).shadow(radius: 5).foregroundColor(.accent))
                        }
                        
                        Spacer().frame(height : 20)

                        NavigationLink(destination: CounselorView_adminLog()){
                            HStack{
                                Text("진행 중인 상담 목록 보기")
                                    .foregroundColor(.accent)
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.accent)
                            }
                        }
                    }
                }
            }
        }
        .padding([.horizontal], 20)
        .navigationBarTitle(Text("소집 문의 시작하기"), displayMode: .inline)
        .background(Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
        .onAppear{
            userManagement.getAdminInfo(){(result) in
                guard let result = result else{return}

                if result == "true"{
                    isAdmin = true
                }

                else{
                    isAdmin = false
                }
            }
        }
    }
}

struct CounselorView_main_Previews: PreviewProvider {
    static var previews: some View {
        CounselorView_main().preferredColorScheme(.dark)
    }
}
