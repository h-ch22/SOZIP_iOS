//
//  changeUserInfo.swift
//  SOZIP
//
//  Created by 하창진 on 2021/09/06.
//

import SwiftUI

struct changeUserInfo: View {
    @StateObject private var userManagement = UserManagement()
    
    @State private var phone = ""
    @State private var isPhoneEditing = false
    
    var body: some View {
        ScrollView{
            ZStack{
                Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                VStack{
                    Image(systemName: "")
                    
                    Spacer().frame(height : 10)

                    Text("변경할 정보를 입력해주세요.")
                        .fontWeight(.semibold)
                        .foregroundColor(.txt_color)
                    
                    Spacer().frame(height : 20)
                    
                    HStack {
                        Image(systemName: "phone.fill")
                        
                        TextField("휴대폰 번호", text:$phone, onEditingChanged: {(editing) in
                            if editing{
                                isPhoneEditing = true
                            }
                            
                            else{
                                isPhoneEditing = false
                            }
                        }).keyboardType(.numberPad)
                        
                        Button(action: {}){
                            Text("인증번호 발송")
                                .foregroundColor(.txt_dark)
                                .font(.caption)
                        }.padding([.vertical], 5)
                        .padding([.horizontal], 10)
                        .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.btn_dark))
                    }
                    .foregroundColor(isPhoneEditing ? Color.accent : Color.txt_color)
                    .padding(20)
                    .padding([.horizontal], 20)
                    .background(RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.btn_color)
                                    .shadow(radius: 5)
                                    .padding([.horizontal],15))
                    
                    Spacer().frame(height : 20)

                    
                }
            }
        }.background(Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
        .navigationBarTitle(Text("사용자 정보 변경"), displayMode: .inline)
        .onAppear(perform: {
            
        })
    }
}

struct changeUserInfo_Previews: PreviewProvider {
    static var previews: some View {
        changeUserInfo()
    }
}
