//
//  Process_Fail.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/27.
//

import SwiftUI

struct Process_Fail: View {
    let msg : String
    let errorCode : String
    @Environment(\.presentations) private var presentations

    var body: some View {
        NavigationView{
            ZStack {
                Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
                VStack{
                    Spacer()

                    Image("ic_error")
                        .resizable()
                        .frame(width: 150, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                    Text("처리 중 문제가 발생했습니다.")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer().frame(height : 20)
                    
                    Text(msg)
                        .multilineTextAlignment(.center)
                    
                    if errorCode != ""{
                        Text("\n\n오류 코드 : \(errorCode)")
                    }
                    
                    Spacer()
                    
                    Button(action: {                        
                        presentations.forEach{
                            $0.wrappedValue = false
                        }
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
