//
//  addBankAccount.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/04.
//

import SwiftUI

struct addBankAccount: View {
    @State private var isaccountEditing = false
    @State private var account = ""
    @State private var selectedBank = -1
    
    var body: some View {
        NavigationView{
            ScrollView{
                ZStack {
                    Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    
                    VStack{
                        Spacer().frame(height : 20)
                        
                        Image(systemName: "wonsign.circle.fill")
                            .resizable()
                            .frame(width : 100, height : 100)
                            .foregroundColor(.accent)
                        
                        Text("계좌 정보를 등록해주세요!")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer().frame(height : 10)
                        
                        Text("소집 멤버들이 정산 금액을 고객님께 보낼 수 있는\n계좌 정보를 등록해주세요.")
                            .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                            .multilineTextAlignment(.center)
                        
                        
                        
                    }.padding(20)
                }
            }
            
            .navigationBarTitle("계좌 정보 등록", displayMode: .inline)
        }
    }
}

struct addBankAccount_Previews: PreviewProvider {
    static var previews: some View {
        addBankAccount()
    }
}
