//
//  ContentView.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/11.
//

import SwiftUI
import Firebase
import AppTrackingTransparency

struct ContentView: View {
    @ObservedObject var helper : UserManagement
    @State private var model : ResultModel?
    
    private let mail : String? = UserDefaults.standard.string(forKey: "signIn_mail")
    private let password : String? = UserDefaults.standard.string(forKey: "signIn_password")
    
    var body: some View {
        ZStack{
            Color.backgroundColor.edgesIgnoringSafeArea(.all)
            VStack{
                Image("appstore")
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .frame(width: 150, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .shadow(radius: 5)
                
                HStack {
                    Text("소집")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .fontWeight(.bold)
                    
                    Text(": SOZIP")
                        .font(.title)
                    
                }
                
                Spacer().frame(height : 20)
                
                ProgressView()
                
            }.padding([.vertical], 20)
            .onAppear(perform: {
                if mail == nil || password == nil{
                    model = .fail
                }

                else{
                    helper.signIn(mail : AES256Util.decrypt(encoded: mail!), password: AES256Util.decrypt(encoded: password!)){result in
                        guard let result = result else {
                            model = .fail

                            return
                        }

                        if result == "success"{
                            model = .success
                        }

                        else{
                            model = .fail
                        }
                    }
                }
            })

            .fullScreenCover(item: $model){item in
                switch (item){
                case .success:
                    TabManager(chatHelper: ChatHelper(), helper : SOZIPHelper())

                case .fail:
                    SignInView(helper : UserManagement())
                }
            }
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(helper : UserManagement())
    }
}
