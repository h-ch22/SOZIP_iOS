//
//  LogView.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/04.
//

import SwiftUI
import Firebase

struct LogView: View {
    @ObservedObject var helper : SOZIPHelper
    @State private var searchText = ""
    @State private var showAlert = false
    
    var body: some View {
        VStack{
            SearchBar(text: $searchText, placeholder: "원하는 소집을 검색해보세요!")
            
            if helper.SOZIPList.isEmpty{
                
                Spacer()
                
                Text("이용 기록이 없어요.")
                    .foregroundColor(.gray)
                
                Spacer()
            }
            
            else{
                ScrollView{
                    LazyVStack{
                        Section(header :
                                    HStack {
                            Text("참여한 소집")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Spacer()
                        }
                        ){
                            ForEach(helper.SOZIPList.filter{
                                self.searchText.isEmpty ? true : $0.SOZIPName.lowercased().contains(searchText.lowercased()) ||
                                $0.store.lowercased().contains(searchText.lowercased())
                            }, id : \.self){  index in
                                if index.participants.keys.contains(Auth.auth().currentUser?.uid as! String) && index.Manager != Auth.auth().currentUser?.uid as! String{
                                    NavigationLink(destination : SOZIPDetailView(sozip: index, helper: SOZIPHelper())){
                                        SOZIPLogModel(data: index)
                                    }
                                    
                                    Spacer().frame(height : 20)
                                }
                            }
                        }
                        
                        Spacer().frame(height : 20)
                        
                        Section(header : HStack {
                            Text("내가 만든 소집")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Spacer()
                        }){
                            ForEach(helper.SOZIPList.filter{
                                self.searchText.isEmpty ? true : $0.SOZIPName.lowercased().contains(searchText.lowercased()) ||
                                $0.store.lowercased().contains(searchText.lowercased())
                            }, id : \.self){  index in
                                if index.Manager == Auth.auth().currentUser?.uid as! String{
                                    NavigationLink(destination : SOZIPDetailView(sozip: index, helper: SOZIPHelper())){
                                        SOZIPLogModel(data: index)
                                    }
                                    
                                    Spacer().frame(height : 20)
                                }
                            }
                        }
                        
                    }
                }
                
            }
            
        }.padding(20)
            .navigationBarTitle(Text("이용 기록"), displayMode: .inline)
            .onAppear(perform: {
                helper.getSOZIP(){result in
                    guard let result = result else{return}
                    
                    if !result{
                        showAlert = true
                    }
                }
            })
        
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text("오류"), message: Text("이용 기록을 불러오는 중 오류가 발생했습니다.\n네트워크 상태를 확인하거나, 나중에 다시 시도하십시오."), dismissButton: .default(Text("확인")))
            })
        
            .background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
    }
}
