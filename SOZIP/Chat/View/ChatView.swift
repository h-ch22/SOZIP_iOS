//
//  ChatView.swift
//  ChatView
//
//  Created by 하창진 on 2021/08/03.
//

import SwiftUI

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

                        ScrollView{
                            LazyVStack(alignment : .center){
                                ForEach(helper.chatPreviewList.filter{
                                    self.searchText.isEmpty ? true : $0.name.lowercased().contains(searchText.lowercased()) ||
                                    $0.last_msg.lowercased().contains(searchText.lowercased())}, id : \.self){  index in
                                        NavigationLink(destination : ChatDetailView(helper: ChatHelper(), rootDocId: index.docId, color: index.color, name : index.name)){
                                            ChatPreviewListModel(data : index)
                                        }
                                    
                                    Spacer().frame(height : 20)
                                }
                            }
                        }
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
