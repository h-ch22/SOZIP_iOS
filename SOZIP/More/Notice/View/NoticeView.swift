//
//  NoticeView.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/04.
//

import SwiftUI

struct NoticeView: View {
    @State private var searchText = ""
    
    var body: some View {
        ZStack(alignment : .top){
            Color.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack{
                SearchBar(text: $searchText, placeholder: "공지사항 검색")
                
                
            }.padding(20)
        }.navigationBarTitle(Text("공지사항"), displayMode: .inline)
    }
}

struct NoticeView_Previews: PreviewProvider {
    static var previews: some View {
        NoticeView()
    }
}
