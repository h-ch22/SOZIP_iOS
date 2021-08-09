//
//  sentFeedback.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/30.
//

import SwiftUI

struct sentFeedback: View {
    @ObservedObject var helper : FeedbackHubHelper
    @State private var showAlert = false
    @State private var navigateToSignInView = false
    
    var body: some View {
        ZStack {
            Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            VStack{
                if helper.list.isEmpty{
                    Text("아직 보낸 피드백이 없어요.")
                        .foregroundColor(.gray)
                }
                
                else{
                    List{
                        ForEach(helper.list, id : \.self){contents in
                            NavigationLink(destination : EmptyView()){
                                FeedbackHubListModel(data : contents)
                            }
                        }
                    }
                }
            }
        }.navigationBarTitle("보낸 피드백", displayMode: .inline)
        .onAppear(perform: {
            helper.getFeedback(){(result) in
                guard let result = result else{return}
                
                switch(result){
                case .noUser:
                    self.showAlert = true
                    
                case .error: break
                case .success: break
                }
            }
        })
        
        .alert(isPresented: $showAlert, content: {
            return Alert(title: Text("사용자 정보 없음"), message: Text("사용자 정보가 없습니다.\n로그인 화면으로 이동합니다."), dismissButton: .default(Text("확인")){self.navigateToSignInView = true})
        })
        
        .fullScreenCover(isPresented: $navigateToSignInView, content: {
            SignInView(helper: UserManagement())
        })
        
        .accentColor(.accent)
    }
}

struct sentFeedback_Previews: PreviewProvider {
    static var previews: some View {
        sentFeedback(helper: FeedbackHubHelper())
    }
}
