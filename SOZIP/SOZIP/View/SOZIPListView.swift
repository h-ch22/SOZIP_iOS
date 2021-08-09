//
//  SOZIPListView.swift
//  SOZIPListView
//
//  Created by 하창진 on 2021/07/31.
//

import SwiftUI

struct SOZIPListView: View {
    @ObservedObject var helper : SOZIPHelper
    @State private var showModal = false
    @State private var showAlert = false
    @State private var searchText = ""
    
    var body: some View {
        NavigationView{
            ZStack {
                Color.backgroundColor.edgesIgnoringSafeArea(.all)
                VStack {
                    HStack{
                        Text("소집 : SOZIP")
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        NavigationLink(destination : navigateToSOZIPMap(data : helper.SOZIPList)
                                        .navigationBarTitle(Text("소집 맵"), displayMode: .inline)
                                        ){
                            Image(systemName : "map.fill")
                                .foregroundColor(.txt_color)
                        }
                    }
                    
                    SearchBar(text: $searchText, placeholder: "원하는 소집을 검색해보세요!")
                    
                    if helper.SOZIPList.isEmpty{
                        
                        Spacer()
                        
                        Text("지금은 진행 중인 소집이 없어요.")
                            .foregroundColor(.gray)
                        
                        Spacer().frame(height : 20)
                        
                        Button(action : {
                            self.showModal = true
                        }){
                            Text("지금 소집을 만들어보세요!")
                        }
                        
                        Spacer()

                    }
                    
                    else{
                        ScrollView{
                            LazyVStack(alignment : .center){
                                ForEach(helper.SOZIPList.filter{
                                    self.searchText.isEmpty ? true : $0.SOZIPName.lowercased().contains(searchText.lowercased()) ||
                                    $0.store.lowercased().contains(searchText.lowercased())
                                }, id : \.self){  index in
                                    if index.status != "closed" && index.status != "paused"{
                                        NavigationLink(destination : SOZIPDetailView(sozip: index, helper: SOZIPHelper())){
                                            SOZIPListModel(data: index)
                                        }
                                        
                                        Spacer().frame(height : 20)
                                    }
                                }
                            }
                        }
                    }
                    
                }.padding(20)
                    .navigationBarHidden(true)
                    .onAppear(perform: {
                        helper.getSOZIP(){(result) in
                            guard let result = result else{return}
                            
                            if !result{
                                showAlert = true
                            }
                        }
                    })
                
                    .alert(isPresented: $showAlert, content: {
                        return Alert(title: Text("오류"),
                                     message: Text("소집 목록을 받아오는 중 문제가 발생했습니다.\n네트워크 상태를 확인하거나 나중에 다시 시도하세요."),
                                     dismissButton: .default(Text("확인")))
                })
            }
            

        }.sheet(isPresented : $showModal){
            addSozipView(receiver : SOZIPLocationReceiver())
        }
        
        
    }
}
