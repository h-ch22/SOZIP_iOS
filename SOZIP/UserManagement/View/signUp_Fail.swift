//
//  signUp_Fail.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/29.
//

import SwiftUI

struct signUp_Fail: View {
    let errorMsg : String
    
    var body: some View {
        NavigationView{
            ZStack {
                Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
                VStack{
                    Spacer()

                    Image("ic_error")
                        .resizable()
                        .frame(width: 150, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                    Text("고객님의 가입 요청을 처리하던 중\n문제가 발생했습니다.")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Spacer().frame(height : 20)
                    
                    Text(errorMsg)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }){
                        HStack{
                            Image(systemName : "chevron.left")
                                .foregroundColor(.white)
                            
                            Text("이전 페이지로")
                                .foregroundColor(.white)
                            
                        }.padding(20)
                        .padding([.horizontal], 100)
                    }.background(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).foregroundColor(.accent).shadow(radius: 5))
                }
            }.navigationBarHidden(true)
        }
    }
}
