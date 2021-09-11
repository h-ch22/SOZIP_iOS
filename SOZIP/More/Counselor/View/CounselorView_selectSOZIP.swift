//
//  CounselorView_selectSOZIP.swift
//  SOZIP
//
//  Created by 하창진 on 2021/09/10.
//

import SwiftUI
import Firebase

struct CounselorView_selectSOZIP: View {
    @ObservedObject var helper : SOZIPHelper
    @State private var selectedSOZIP = ""
    @State private var searchText = ""
    
    var body: some View {
        ZStack{
            Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            VStack{
                Spacer().frame(height : 20)
                
                Image("ic_counselor")
                    .resizable()
                    .frame(width : 150, height : 150)
                
                Spacer().frame(height : 10)
                
                Text("먼저 소집을 선택해주세요!")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.txt_color)
                
                Spacer().frame(height : 10)
                
                Text("어떤 소집에서 문제가 발생하셨나요?")
                    .font(.caption)
                    .foregroundColor(.txt_color)
                
                Spacer().frame(height : 20)
                
                SearchBar(text: $searchText, placeholder: "이용 기록 검색")
                
                ScrollView{
                    LazyVStack{
                        ForEach(helper.SOZIPList.filter{
                            self.searchText.isEmpty ? true : $0.SOZIPName.lowercased().contains(searchText.lowercased())
                        }, id : \.self){  index in
                            if index.participants.keys.contains(Auth.auth().currentUser?.uid ?? ""){
                                Button(action: {
                                    selectedSOZIP = index.docId
                                }){
                                    SOZIPCounselorListModel(data: index, isSelected: $selectedSOZIP)
                                }
                                
                                Spacer().frame(height : 15)
                                
                            }
                        }
                    }
                }
                
                NavigationLink(destination : CounselorView_chat(docId : selectedSOZIP)){
                    HStack{
                        Text("다음 단계로")
                            .foregroundColor(.white)
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white)
                    }.padding(20)
                    .padding([.horizontal], 60)
                    .background(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).shadow(radius: 5).foregroundColor(.accent))
                }
                .isHidden(selectedSOZIP == "")
                
            }
        }
        
        .padding(20)
        .background(Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
        .navigationBarTitle(Text("소집 선택하기"), displayMode: .inline)
        .onAppear{
            helper.getSOZIP(){result in
                guard let result = result else{return}
            }
        }
    }
}
