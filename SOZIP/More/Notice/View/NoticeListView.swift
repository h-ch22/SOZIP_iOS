//
//  NoticeView.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/04.
//

import SwiftUI

struct NoticeListView: View {
    @State private var searchText = ""
    @ObservedObject var helper : NoticeHelper
    
    var body: some View {
        ZStack(alignment : .top){
            Color.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack{
                SearchBar(text: $searchText, placeholder: "공지사항 검색")
                
                if helper.notice.isEmpty{
                    Spacer()
                    
                    Text("공지사항이 없습니다.")
                        .foregroundColor(.gray)
                    
                    Spacer()
                }
                
                else{
                    List{
                        ForEach(helper.notice.indices.filter{
                            self.searchText.isEmpty ? true : helper.notice[$0].noticeTitle.lowercased().contains(searchText.lowercased()) || helper.notice[$0].contents.lowercased().contains(searchText.lowercased())
                        }, id : \.self){index in
                            NavigationLink(destination : NoticeDetailView(data : helper.notice[index], helper: helper)){
                                NoticeListModel(data: helper.notice[index])
                            }
                        }.listRowBackground(Color.backgroundColor)
                    }
                }
                
            }.padding(20)
        }.navigationBarTitle(Text("공지사항"), displayMode: .inline)
        .onAppear(perform: {
            helper.getNotice(){result in
                guard let result = result else{return}
            }
        })
    }
}

//struct NoticeListView_Previews: PreviewProvider {
//    static var previews: some View {
//        NoticeListView()
//    }
//}
