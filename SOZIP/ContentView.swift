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
        VStack{
            Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        }.onAppear(perform: {
            if Auth.auth().currentUser?.uid != nil{
                helper.updateToken()
                model = .success
            }
            
            else if mail == nil || password == nil{
                print("mail variable is nil.")
                model = .fail
            }
            
            else{
                print("mail variable is not nil.")

                helper.signIn(mail: mail!, password: password!){result in
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
                TabManager(helper : SOZIPHelper())
                
            case .fail:
                SignInView(helper : UserManagement())
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(helper : UserManagement())
    }
}
