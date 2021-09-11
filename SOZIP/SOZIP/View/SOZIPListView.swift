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
    @State private var offset = CGFloat.zero
    @State private var selectedCategory = "All"

    let data : [SOZIPDataModel]
    let categoryList : [String]
    
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
        VStack {
            HStack{
                Text("소집 : SOZIP")
                    .fontWeight(.bold)
                
                Spacer()
                
                NavigationLink(destination : NotificationView().environmentObject(UserManagement())){
                    Image(systemName: "bell.fill")
                        .resizable()
                        .frame(width : 20, height : 20)
                        .foregroundColor(.txt_color)
                }
            }.padding(20)
            
            Spacer().frame(height : 15)
            
            HStack {
                Text("\(greet)\n\(userManagement.name)님!")
                
                Spacer()
            }.padding([.horizontal], 20)
            
            SearchBar(text: $searchText, placeholder: "원하는 소집을 검색해보세요!")
                .padding([.horizontal], 20)
            
            Ad_BannerViewController().frame(height: 50, alignment: .leading)
            
            if data.isEmpty{
                
                Group{
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
                }.padding([.horizontal], 20)
                
            }
            
            else{
                ScrollView(.horizontal){
                    LazyHStack{
                        Button(action: {
                            self.selectedCategory = "All"
                        }){
                            Text("전체")
                                .foregroundColor(self.selectedCategory == "All" ? .white : .accent)
                        }.padding(10)
                        .padding([.horizontal], 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(self.selectedCategory == "All" ? .accent : .clear)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius : 10)
                                .stroke(lineWidth : 2)
                                .foregroundColor(.accent)
                                .isHidden(self.selectedCategory == "All" ? true : false)
                        )
                        
                        ForEach(0..<categoryList.indices.count){index in
                            Button(action: {
                                self.selectedCategory = categoryList[index]
                            }){
                                Text(categoryList[index])
                                    .foregroundColor(self.selectedCategory == categoryList[index] ? .white : .accent)
                            }.padding(10)
                            .padding([.horizontal], 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(self.selectedCategory == categoryList[index] ? .accent : .clear)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius : 10)
                                    .stroke(lineWidth : 2)
                                    .foregroundColor(.accent)
                                    .isHidden(self.selectedCategory == categoryList[index] ? true : false)
                            )
                        }
                    }
                }
                .frame(height: 40)
                .padding([.horizontal], 20)
                .isHidden(self.categoryList.indices.count <= 1)
                    
                Spacer().frame(height : 15)

                ScrollView{
                    LazyVStack(alignment : .center){
                        ForEach(data.indices.filter{
                            self.searchText.isEmpty ? true : data[$0].SOZIPName.lowercased().contains(searchText.lowercased())
                        }, id : \.self){  index in
                            if selectedCategory == "All" || data[index].category == selectedCategory{
                                if data[index].status != "closed" && data[index].status != "paused" && data[index].status != "end" && data[index].currentPeople <= data[index].firstCome{
                                    NavigationLink(destination : SOZIPDetailView(sozip: data[index], helper: SOZIPHelper())){
                                        SOZIPListModel(data: data[index])
                                    }
                                    
                                    Spacer().frame(height : 20)
                                }
                            }
                            
                        }
                    }
                }.padding([.horizontal], 20)
                
            }
        }
        .navigationBarHidden(true)
        .animation(.easeOut)
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
        
        .sheet(isPresented : $showModal){
            addSozipView(isShowing: $showModal, receiver : SOZIPLocationReceiver(), userManagement: UserManagement())
        }
    }
}
