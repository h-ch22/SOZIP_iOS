//
//  Register_Success.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/28.
//

import SwiftUI

struct Register_Success: View {
    @State private var navigateToHome = false
    @State private var count = 5
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            VStack{
                Spacer()
                
                Group {
                    Image("ic_checkmark")
                        .resizable()
                        .frame(width: 100, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                    Spacer().frame(height : 40)

                    Text("회원가입이 완료되었습니다.")
                        .font(.title)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.txt_color)
                    
                    Spacer().frame(height : 20)

                    Text("\(count)초 후 메인 페이지로 이동해요!")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer()
                }
                
                Button(action: {
                    self.navigateToHome = true
                }){
                    HStack{
                        Text("시작하기")
                            .foregroundColor(.white)
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white)
                    }.padding(20)
                    .padding([.horizontal], 100)
                    .background(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                                    .shadow(radius: 5)
                                    .foregroundColor(.accent))
                }
                

            }.onReceive(timer, perform: { time in
                count -= 1
                
                if self.count <= 0{
                    self.navigateToHome = true
                }
            })
            
            .fullScreenCover(isPresented: $navigateToHome, content: {
                TabManager(helper : SOZIPHelper())
            })
        }
    }
}

struct Register_Success_Previews: PreviewProvider {
    static var previews: some View {
        Register_Success()
    }
}
