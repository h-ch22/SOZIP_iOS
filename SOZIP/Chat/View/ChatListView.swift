//
//  ChatListView.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/23.
//

import SwiftUI

struct ChatListView: View {
    @ObservedObject var helper : ChatHelper
    @ObservedObject var SOZIPHelper : SOZIPHelper

    let data : [ChatListDataModel]
    let SOZIPData : [SOZIPDataModel]
    
    @State private var searchText = ""

    var body: some View {
        VStack{
            HStack{
                Text("소집 : SOZIP")
                    .fontWeight(.bold)
                
                Spacer()
            }.padding(20)
            
            SearchBar(text: $searchText, placeholder: "채팅 검색").padding([.horizontal], 20)
                
            Spacer().frame(height : 15)
            
            Ad_BannerViewController().frame(height: 50, alignment: .leading)
            
            if data.isEmpty{
                VStack{
                    Spacer()
                    
                    Text("채팅이 없습니다.\n소집을 만들거나 참여해서 새로운 채팅을 시작해보세요!")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    
                    Spacer()
                }.padding([.horizontal], 20)
            }
            
            else{
                ScrollView{
                    LazyVStack{
                        ForEach(data.indices.filter{
                            self.searchText.isEmpty ? true : data[$0].SOZIPName.lowercased().contains(searchText.lowercased()) || data[$0].last_msg.lowercased().contains(searchText.lowercased()) || data[$0].participants.values.contains(searchText.lowercased())
                        }, id : \.self){index in
                            NavigationLink(destination : ChatDetailView(SOZIPData: data[index], SOZIPHelper : SOZIPHelper, SOZIPInfo : SOZIPData.first(where: {$0.docId == data[index].docId})!)){
                                ChatListModel(data: data[index])
                            }
                        }
                    }.padding([.horizontal],20)
                }
//                List{
//                    ForEach(data.indices.filter{
//                        self.searchText.isEmpty ? true : data[$0].SOZIPName.lowercased().contains(searchText.lowercased()) || data[$0].last_msg.lowercased().contains(searchText.lowercased()) || data[$0].participants.values.contains(searchText.lowercased())
//                    }, id : \.self){index in
//                        NavigationLink(destination : ChatDetailView(SOZIPData: data[index], SOZIPHelper : SOZIPHelper, SOZIPInfo : SOZIPData.first(where: {$0.docId == data[index].docId})!)){
//                            ChatListModel(data: data[index])
//                        }
//                    }.listRowBackground(Color.backgroundColor)
//                }
            }
        }
        .animation(.easeOut)
        .navigationBarHidden(true)
    }
}

//struct ChatListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatListView()
//    }
//}
