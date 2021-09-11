//
//  addBankAccount.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/11.
//

import SwiftUI

struct addBankAccount: View {
    @State private var bank = ["NH농협", "KB국민은행", "신한은행", "우리은행", "하나은행", "IBK기업은행", "SC제일은행", "씨티은행", "KDB산업은행", "SBI저축은행", "새마을은행", "대구은행", "광주은행", "우체국", "신협", "전북은행", "경남은행", "부산은행", "수협", "제주은행", "저축은행", "산림조합", "토스뱅크", "케이뱅크", "카카오뱅크", "HSBC", "중국공산", "JP모간", "도이치", "BNP파리바", "BOA", "중국건설"]
    
    @State private var brokerage = ["토스증권", "키움", "KB증권", "미래에셋대우", "삼성", "NH투자", "유안타", "대신", "한국투자", "신한금융투자", "유진투자", "한화투자", "DB금융투자", "하나금융", "하이투자", "현대차증권", "신영", "이베스트", "교보", "메리츠증권", "KTB투자", "SK", "부국", "케이프투자", "한국포스증권", "카카오페이증권"]
    
    @State private var bankExpanded = true
    @State private var brokerageExpanded = false
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView{
            ZStack{
                Color.backgroundColor.edgesIgnoringSafeArea(.all)
                
                VStack{
                    Image(systemName: "wonsign.circle.fill")
                        .resizable()
                        .frame(width : 100, height : 100)
                        .foregroundColor(.accent)
                    
                    Spacer().frame(height : 20)
                    
                    Text("먼저 은행 또는 증권사를 선택해주세요!")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer().frame(height : 20)
                    
                    List{
                        Section(header : Text("은행")){
                            ForEach(0..<bank.count, id : \.self){index in
                                NavigationLink(destination : enterAccountNumber(bank : $bank[index]).environmentObject(UserManagement())){
                                    Text(bank[index])
                                }
                            }
                        }
                        
                        Section(header : Text("증권사")){
                            ForEach(0..<brokerage.count, id : \.self){index in
                                NavigationLink(destination : enterAccountNumber(bank: $brokerage[index]).environmentObject(UserManagement())){
                                    Text(brokerage[index])
                                }
                            }
                        }
                        
                    }.listStyle(SidebarListStyle())
                    
                }.padding(20)
                .navigationBarTitle("계좌 정보 등록", displayMode: .inline)
                .navigationBarItems(leading: Button("닫기"){
                    self.presentationMode.wrappedValue.dismiss()
                })
            }
            
        }
    }
}

struct addBankAccount_Previews: PreviewProvider {
    static var previews: some View {
        addBankAccount()
            .preferredColorScheme(.dark)
    }
}
