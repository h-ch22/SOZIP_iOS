//
//  enterAccountNumber.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/24.
//

import SwiftUI

struct enterAccountNumber: View {
    @Binding var bank : String
    @State private var accountNumber = ""
    @State private var name = ""
    
    @State private var isAccountNumberEditing = false
    @State private var isNameEditing = false
    @State private var consonant : String = ""
    
    @State private var alertType : addAccountModel? = nil
    @State private var showAlert = false
    @State private var isProcessing = false
    
    @EnvironmentObject var userManagement : UserManagement
    
    func splitText() -> Bool{
        consonant = ""
        var unicodeArr : [UnicodeScalar] = []
        
        for i in 0..<name.count{
            let index = name.index(name.startIndex, offsetBy: i)

            if String(name[index]) != " "{
                let char : String = String(name[index])
                
                let val = UnicodeScalar(char)?.value
                guard let value = val else{
                    return false
                }
                
                if value >= 0xac00 && value <= 0xd7af{
                    let x = (value - 0xac00) / 28 / 21
                    
                    let result = UnicodeScalar(0x1100 + x)
                    
                    unicodeArr.append(result!)
                }
                
                else{
                    unicodeArr.append(UnicodeScalar(val!)!)
                }
            }
        }
        
        for i in unicodeArr.indices{
            consonant.append("\(unicodeArr[i])")
        }
        
        return true
    }
    
    var body: some View {
        ZStack{
            Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            KeyboardView{
                ScrollView{
                    VStack{
                        Spacer().frame(height : 20)

                        Image(systemName: "wonsign.circle.fill")
                            .resizable()
                            .frame(width : 100, height : 100)
                            .foregroundColor(.accent)
                        
                        Spacer().frame(height : 20)
                        
                        Text("\(bank)\n계좌 정보를 입력해주세요.")
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Spacer().frame(height : 20)
                        
                        Group{
                            HStack {
                                Image(systemName: "wonsign.circle.fill")
                                
                                TextField("계좌 번호", text:$accountNumber, onEditingChanged: {(editing) in
                                    if editing{
                                        isAccountNumberEditing = true
                                    }
                                    
                                    
                                    else{
                                        isAccountNumberEditing = false
                                    }
                                    
                                })
                                .keyboardType(.numberPad)
                            }
                            .foregroundColor(isAccountNumberEditing ? Color.accent : Color.txt_color)
                            .padding(20)
                            .padding([.horizontal], 20)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.btn_color).shadow(radius: 5)
                                            .padding([.horizontal],15))
                            
                            Spacer().frame(height : 20)
                            
                            HStack {
                                Image(systemName: "person.fill.viewfinder")
                                
                                TextField("이름", text:$name, onEditingChanged: {(editing) in
                                    if editing{
                                        isNameEditing = true
                                    }
                                    
                                    else{
                                        isNameEditing = false
                                        _ = splitText()
                                    }
                                    
                                })
                            }
                            .foregroundColor(isNameEditing ? Color.accent : Color.txt_color)
                            .padding(20)
                            .padding([.horizontal], 20)
                            .background(RoundedRectangle(cornerRadius: 10)
                                            .foregroundColor(.btn_color)
                                            .shadow(radius: 5)
                                            .padding([.horizontal],15))
                            
                            if consonant != ""{
                                Spacer().frame(height : 10)

                                Text("소집 멤버들에게 계좌 이름이 \(consonant)으로 표시됩니다.")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            else{
                                Spacer().frame(height : 10)

                                Text("이름은 소집 멤버들에게 초성으로만 표시됩니다.")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        
                        Spacer().frame(height : 20)
                        
                        Button(action : {
                            if name != "" && accountNumber != ""{
                                isProcessing = true
                                
                                userManagement.addAccount(bank: bank, accountNumber: accountNumber, name: name){result in
                                    guard let result = result else{return}
                                    
                                    isProcessing = false
                                    
                                    if result == "success"{
                                        alertType = .success
                                        showAlert = true
                                    }
                                    
                                    else if result == "noUser"{
                                        alertType = .noUser
                                        showAlert = true
                                    }
                                    
                                    else{
                                        alertType = .error
                                        showAlert = true
                                    }
                                }
                            }
                            
                            else{
                                alertType = .emptyField
                                showAlert = true
                            }
                            
                        }){
                            HStack{
                                Text("계좌 등록하기")
                                    .foregroundColor(.white)
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                            }.padding(20)
                            .frame(width : 300)
                            .background(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).shadow(radius: 5))
                            .disabled(self.name.isEmpty || self.accountNumber.isEmpty)
                            
                        }
                    }
                }
            } toolBar:{
                HStack {
                    Spacer()
                    Button(action: {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }, label: {
                        Text("완료")
                    })
                }.padding()
            }
            .navigationBarTitle(Text("계좌 정보 입력"))
            
            .overlay(
                ProcessView()
                    .isHidden(!isProcessing)
            )
            
            .alert(item: $alertType){model in
                switch model{
                case .success:
                    return Alert(title: Text("계좌 정보 추가 완료"),
                                 message: Text("계좌 정보를 추가했어요!"),
                                 dismissButton: .default(Text("확인")))
                case .error:
                    return Alert(title: Text("업로드 오류"),
                                 message: Text("정보를 업데이트 하는 중 오류가 발생했습니다.\n네트워크 상태를 확인하거나, 나중에 다시 시도하세요."),
                                 dismissButton: .default(Text("확인")))
                    
                case .noUser:
                    return Alert(title: Text("사용자 정보 없음"),
                                 message: Text("사용자 정보가 없습니다.\n로그아웃 후 다시 로그인해주세요."),
                                 dismissButton: .default(Text("확인")))
                    
                case .emptyField:
                    return Alert(title: Text("공백 필드"),
                                 message: Text("모든 필드를 입력해주세요."),
                                 dismissButton: .default(Text("확인")))
                }
            }
            
        }
    }
}

struct enterAccountNumber_Previews: PreviewProvider {
    static var previews: some View {
        enterAccountNumber(bank : .constant("KB국민은행"))
    }
}
