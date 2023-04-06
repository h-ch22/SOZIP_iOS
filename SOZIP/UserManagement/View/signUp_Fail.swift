//
//  signUp_Fail.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/29.
//

import SwiftUI

struct signUp_Fail: View {
    let errorMsg : String
    @State private var showPrevious = false
    
    var body: some View {
        NavigationView{
            ZStack {
                Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
                VStack{
                    Spacer()

                    Image(systemName: "exclamationmark.triangle.fill")
                        .resizable()
                        .frame(width: 150, height: 130, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.red)
                    
                    Text("고객님의 가입 요청을 처리하는 중\n문제가 발생했습니다.")
                        .font(.title)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                    
                    Spacer().frame(height : 20)
                    
                    Text(errorMsg)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    Button(action: {
                        showPrevious = true
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
                .fullScreenCover(isPresented : $showPrevious, content :{
                    SignInView(helper : UserManagement())
                })
        }
    }
}

struct signUp_Fail_previews : PreviewProvider{
    static var previews: some View{
        signUp_Fail(errorMsg : "")
    }
}
