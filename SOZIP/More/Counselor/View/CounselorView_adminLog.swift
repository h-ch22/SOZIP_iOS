//
//  CounselorView_adminLog.swift
//  SOZIP
//
//  Created by 하창진 on 2021/09/10.
//

import SwiftUI

struct CounselorView_adminLog: View {
    @StateObject private var helper = CounselorHelper()
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

                Text("원하시는 상담을 선택하세요")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.txt_color)
                
                Spacer().frame(height : 10)
                
                SearchBar(text: $searchText, placeholder: "상담 내역 검색").padding([.horizontal], 20)

                if helper.logList.isEmpty{
                    Spacer()
                    
                    Text("진행 중인 상담이 없습니다.")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    
                    Spacer()
                }
                
                else{
                    List{
                        ForEach(helper.logList.indices.filter{
                            self.searchText.isEmpty ? true : helper.logList[$0].SOZIPName?.lowercased().contains(searchText.lowercased()) as! Bool
                        }, id : \.self){index in
                            NavigationLink(destination : CounselorView_chat(docId: helper.logList[index].docId ?? "", type : "Manager")){
                                CounselorLogModel(data: helper.logList[index])
                            }
                        }.listRowBackground(Color.backgroundColor)
                    }
                }
            }
            .padding([.horizontal], 20)

        }
        .onAppear{
            helper.getAdminCounselors(){result in
                guard let result = result else{return}
            }
        }
        
        .animation(.easeOut)
        
        .navigationBarTitle(Text("진행 중인 상담"), displayMode: .inline)
    }
}

struct CounselorView_adminLog_Previews: PreviewProvider {
    static var previews: some View {
        CounselorView_adminLog()
    }
}
