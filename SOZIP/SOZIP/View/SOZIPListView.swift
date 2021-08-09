//
//  SOZIPListView.swift
//  SOZIPListView
//
//  Created by 하창진 on 2021/07/31.
//

import SwiftUI

struct SOZIPListView: View {
    @EnvironmentObject var userManagement : UserManagement
    @State private var greet : String = ""
    @State private var showATTPermissionView = false
    @State private var showBETAModal = false
    @ObservedObject var helper : SOZIPHelper
    @State private var showModal = false
    @State private var showAlert = false
    @State private var searchText = ""
    let data : [SOZIPDataModel]
    
    func calculate_Time(){
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        
        let current_string = formatter.string(from: Date())
        let current_hour = Int(current_string) ?? 0
        
        if current_hour >= 6 && current_hour <= 11{
            greet = "좋은 아침이예요,"
        }
        
        else if current_hour >= 12 && current_hour <= 17{
            greet = "좋은 오후예요,"
        }
        
        else if current_hour >= 18{
            greet = "좋은 밤이예요,"
        }
        
        else if current_hour >= 0 && current_hour <= 5{
            greet = "좋은 밤이예요,"
        }
    }
    
    var body: some View {
        NavigationView{
            ZStack {
                Color.backgroundColor.edgesIgnoringSafeArea(.all)
                VStack {
                    HStack{
                        Text("소집 : SOZIP")
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        NavigationLink(destination : NotificationCenter().environmentObject(UserManagement())){
                            Image(systemName: "bell.fill")
                                .resizable()
                                .frame(width : 20, height : 20)
                                .foregroundColor(.txt_color)
                        }
                    }
                    
                    Spacer().frame(height : 15)
                    
                    HStack {
                        Text("\(greet)\n\(userManagement.name)님!")
                        
                        Spacer()
                    }
                    
                    SearchBar(text: $searchText, placeholder: "원하는 소집을 검색해보세요!")
                    
                    if data.isEmpty{
                        
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
                                ForEach(data.filter{
                                    self.searchText.isEmpty ? true : $0.SOZIPName.lowercased().contains(searchText.lowercased()) 
                                }, id : \.self){  index in
                                    if index.status != "closed" && index.status != "paused" && index.status != "end"{
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
                        calculate_Time()
                        
                        if !UserDefaults.standard.bool(forKey: "launchedBefore"){
                            self.showATTPermissionView = true
                            self.showBETAModal = true
                        }
                    })
                
                .fullScreenCover(isPresented: $showATTPermissionView){
                    requestATTPermission()
                }
                
                .sheet(isPresented: $showBETAModal, content: {
                    IntroduceFeedbackHub()
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
