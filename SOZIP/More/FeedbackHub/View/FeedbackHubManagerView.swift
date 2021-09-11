//
//  FeedbackHubManagerView.swift
//  SOZIP
//
//  Created by 하창진 on 2021/09/10.
//

import SwiftUI

struct FeedbackHubManagerView: View {
    @State private var showProcessView = true
    @StateObject private var helper = FeedbackHubHelper()
    @State private var showAlert = false

    var body: some View {
        ZStack{
            Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            VStack{
                if showProcessView{
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                    
                    Spacer().frame(height : 10)
                    
                    Text("안전하게 피드백 정보를 불러오고 있습니다.")
                        .font(.caption)
                        .foregroundColor(.txt_color)
                }
                
                else{
                    if helper.managerList.isEmpty{
                        Text("아직 피드백 목록이 없어요.")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    else{
                        List{
                            ForEach(helper.managerList, id : \.self){contents in
                                NavigationLink(destination : FeedbackHubManagerDetailView(data : contents)){
                                    FeedbackHubListModel(data : contents)
                                }
                            }.listRowBackground(Color.backgroundColor)
                        }
                    }
                }
            }
        }.navigationBarTitle(Text("피드백 관리"), displayMode: .inline)
        
        .navigationBarItems(trailing: Button(action: {
            showProcessView = true
            
            helper.getAllFeedbacks(){result in
                guard let result = result else{return}
                
                switch(result){
                case .noUser: break
                case .error:
                    showAlert = true
                case .success:
                    showProcessView = false
                case .noContents: break
                case .noCategory: break
                }
            }
        }){
            Image(systemName: "arrow.clockwise")
        })
        
        .onAppear{
            helper.getAllFeedbacks(){result in
                guard let result = result else{return}
                
                switch(result){
                case .noUser: break
                case .error:
                    showAlert = true
                case .success:
                    showProcessView = false
                case .noContents: break
                case .noCategory: break
                }
            }
        }
        
        .alert(isPresented: $showAlert, content: {
            return Alert(title: Text("오류"), message: Text("피드백 목록을 받아오는 중 오류가 발생했습니다."), dismissButton: .default(Text("확인")))
        })
        
        .onAppear{
            self.showProcessView = true
        }
    }
}

struct FeedbackHubManagerView_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackHubManagerView()
            .preferredColorScheme(.dark)
    }
}
