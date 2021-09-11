//
//  Tutorial_Validate.swift
//  SOZIP
//
//  Created by 하창진 on 2021/09/04.
//

import SwiftUI

struct Tutorial_Validate: View {
    @State private var current = 0
    @State private var showAlert = false
    let method : TutorialScreenViewModel?
    
    var body: some View {
        NavigationView{
            VStack {
                TabView(selection : $current,
                        content : {
                            switch method{
                            case .mobile :
                                ForEach(TutorialContentsData.contents_mobileIdCard){data in
                                    OnBoardingView(data : data)
                                        .tag(data.id)
                                }
                            case .none:
                                EmptyView()
                                
                            case .real:
                                ForEach(TutorialContentsData.contents_idCard){data in
                                    OnBoardingView(data : data)
                                        .tag(data.id)
                                }
                            }
                            
                        }
                ).tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .automatic))
                Spacer()
                
                Button(action : {
                    withAnimation(.easeInOut){
                        if current == 0 && method == .mobile{
                            current += 1
                            let url = "https://apps.apple.com/kr/app/%EC%A0%84%EB%B6%81%EB%8C%80%EC%95%B1/id1510698205"
                                                        
                            if let appUrl = URL(string: url){
                                if UIApplication.shared.canOpenURL(appUrl){
                                    UIApplication.shared.open(appUrl, options : [:], completionHandler: nil)
                                }
                                
                                else{
                                    showAlert = true
                                }
                            }
                        }
                        
                        if current == 1 && method == .mobile{
                            
                        }
                        
                        if current == 2 && method == .mobile{
                            
                        }
                        
                        else{
                            
                        }
                    }
                }){
                    if self.current < 2{
                        Image(systemName: "chevron.right")
                            .font(.system(size: 20, weight : .semibold))
                            .foregroundColor(.txt_color)
                            .frame(width: 60, height: 60)
                            .background(Color.btn_color)
                            .clipShape(Circle())
                            .overlay(
                                ZStack{
                                    Circle()
                                        .stroke(Color.btn_color.opacity(0.04), lineWidth: 4)
                                    
                                    Circle()
                                        .trim(from: 0, to: CGFloat(current+1) / CGFloat(3))
                                        .stroke(Color.btn_color, lineWidth: 4)
                                        .rotationEffect(.init(degrees: -90))
                                    
                                }.padding(-15)
                            )
                    }
                    
                    else{
                        
                    }
                    
                }
                
                Spacer()
                
            }.background(Color.backgroundColor)
            .padding(20)
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text("App Store를 열 수 없음"),
                      message: Text("App Store를 열 수 없습니다."),
                      dismissButton: .default(Text("확인")){
                        
                      })
            })
        }

    }
}

struct Tutorial_Validate_Previews: PreviewProvider {
    static var previews: some View {
        Tutorial_Validate(method : .mobile)
    }
}
