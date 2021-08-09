//
//  ChatView.swift
//  ChatView
//
//  Created by 하창진 on 2021/08/03.
//

import SwiftUI
import UIKit

struct ChatView: View {
    @State private var searchText = ""
    @ObservedObject var helper : ChatHelper

    
    var body: some View {
        NavigationView{
            ZStack {
                Color.backgroundColor.edgesIgnoringSafeArea(.all)
                
                VStack{
                    HStack{
                        Text("소집 : SOZIP")
                            .fontWeight(.bold)
                        
                        Spacer()
                    }
                    
                    SearchBar(text: $searchText, placeholder: "채팅 목록 검색")
                    
                    if helper.chatPreviewList.isEmpty{
                        Spacer()
                        
                        Text("채팅이 없어요.\n소집을 만들거나 참여하고, 채팅을 시작해보세요!")
                            .foregroundColor(.gray)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                    
                    else{
                        Spacer().frame(height : 20)
                        
                        List{
                            Section(header : Text("진행 중인 소집")){
                                ForEach(helper.chatPreviewList.filter{
                                            self.searchText.isEmpty ? true : $0.name.lowercased().contains(searchText.lowercased()) ||
                                                $0.last_msg.lowercased().contains(searchText.lowercased())}, id : \.self){  index in
                                    if index.currentPeople > 0 && index.status != "closed"{
                                        NavigationLink(destination : ChatDetailView(helper: ChatHelper(), rootDocId: index.docId, name : index.name)){
                                            ChatPreviewListModel(data : index)
                                        }
                                                                                
                                        Divider().background(Color.txt_color)
                                    }
                                }
                            }
                            
                            Section(header : Text("종료된 소집")){
                                ForEach(helper.chatPreviewList.filter{
                                            self.searchText.isEmpty ? true : $0.name.lowercased().contains(searchText.lowercased()) ||
                                                $0.last_msg.lowercased().contains(searchText.lowercased())}, id : \.self){  index in
                                    if index.currentPeople <= 0 || index.status == "closed"{
                                        NavigationLink(destination : ChatDetailView(helper: ChatHelper(), rootDocId: index.docId, name : index.name)){
                                            ChatPreviewListModel(data : index)
                                        }

                                                                                
                                        Divider().background(Color.txt_color)
                                    }
                                }

                            }
                            
                        }.listStyle(SidebarListStyle())
                        
                    }
                    
                }.padding([.horizontal], 20)
                .onAppear(perform: {
                    helper.getChatList(){result in
                        guard let result = result else{return}
                        
                        if result == "error"{
                            
                        }
                        
                        else if result == "noUser"{
                            
                        }
                    }
                })
                
                .navigationBarHidden(true)
                
            }
        }
        
    }
    
}
