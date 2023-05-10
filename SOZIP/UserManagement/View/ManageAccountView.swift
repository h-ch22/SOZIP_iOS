//
//  ManageAccountView.swift
//  SOZIP
//
//  Created by 하창진 on 2021/09/06.
//

import SwiftUI
import SwiftUIPager

struct ManageAccountView: View {
    @State private var showModal = false
    @State private var showAlert = false
    @State private var showSignIn = false

    @State private var alertType : ManageAccountAlertType? = nil
    @State private var page : Page = Page.first()

    @State private var accountNumber = ""
    @State private var name = ""
    @State private var consonant = ""

    @State private var isAccountNumberEditing = false
    @State private var isNameEditing = false
        
    @StateObject var userManagement = UserManagement()

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
    
    func accountView(_ page : Int) -> some View{
        VStack{
            HStack{
                Spacer()
                
                Image(systemName : "checkmark.circle.fill")
                    .foregroundColor(.white)
                    .isHidden(self.page.index != page)
            }
            
            Text(AES256Util.decrypt(encoded: userManagement.accounts[page].bank))
                .font(.caption)
                .foregroundColor(.white)
            
            Text(AES256Util.decrypt(encoded: userManagement.accounts[page].accountNumber))
                .foregroundColor(.white)
                .fontWeight(.semibold)
            
            Text(AES256Util.decrypt(encoded: userManagement.accounts[page].name))
                .foregroundColor(.white)
                .font(.caption2)
            
        }
        //        .frame(width: 250, height: 80)
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(self.page.index == page ? .accent : .gray)
                        .shadow(radius: 5))
    }
    
    var body: some View {
        ScrollView{
            ZStack {
                Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
                VStack{
                    if userManagement.accounts.isEmpty{
                        Spacer()
                        
                        Text("추가된 계좌 정보가 없습니다.")
                        
                        Spacer()
                    }
                    
                    else{
                        Spacer().frame(height : 20)

                        Pager(page : page,
                              data : userManagement.accounts.indices,
                              id : \.self){
                            self.accountView($0)
                        }
                        .interactive(scale : 0.8)
                        .interactive(opacity: 0.5)
                        .itemSpacing(10)
                        .pagingPriority(.simultaneous)
                        .itemAspectRatio(1.3, alignment: .start)
                        .padding(20)
                        .sensitivity(.high)
                        .preferredItemSize(CGSize(width : 250, height : 120))
                        .onPageWillChange({(newIndex) in
                            let generator = UIImpactFeedbackGenerator(style: .soft)
                            generator.impactOccurred()
                        })
                        
                        .onPageChanged({(newIndex) in
                            self.accountNumber = AES256Util.decrypt(encoded: userManagement.accounts[page.index].accountNumber)
                            self.name = AES256Util.decrypt(encoded: userManagement.accounts[page.index].name)
                            
                            _ = splitText()
                        })
                        
                        .onAppear{
                            if !userManagement.accounts.isEmpty{
                                self.accountNumber = AES256Util.decrypt(encoded: userManagement.accounts[0].accountNumber)
                                self.name = AES256Util.decrypt(encoded: userManagement.accounts[0].name)
                            }
                        }
                        
                        .frame(height : 150)
                        
                        Spacer().frame(height : 20)

                        Divider()
                        
                        HStack{
                            Text("계좌 정보 관리")
                                .font(.headline)
                                .foregroundColor(.txt_color)
                            
                            Spacer()
                        }
                        
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
                        
                        Group{
                            if self.name != "" && self.accountNumber != ""{
                                if self.name != AES256Util.decrypt(encoded: userManagement.accounts[page.index].name) || self.accountNumber != AES256Util.decrypt(encoded: userManagement.accounts[page.index].accountNumber){
                                    Spacer().frame(height : 20)

                                    Button(action : {
                                        alertType = .update
                                        showAlert = true
                                    }){
                                        HStack{
                                            Text("계좌 정보 변경하기")
                                                .foregroundColor(.white)
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.white)
                                        }.padding(20)
                                        .frame(width : 300)
                                        .background(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).shadow(radius: 5))
                                    }
                                }
                            }

                            Spacer().frame(height : 20)
                            
                            Button(action : {
                                alertType = .remove
                                showAlert = true
                            }){
                                HStack{
                                    Image(systemName: "xmark")
                                        .foregroundColor(.red)
                                    
                                    Text("계좌 제거하기")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                }.padding(20)
            }
            
        }.background(Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
        .navigationBarTitle("계좌 정보 관리", displayMode: .inline)
        .navigationBarItems(trailing: Button(action : {
            showModal = true
        }){
            Image(systemName: "plus").foregroundColor(.red)
        })
        
        .sheet(isPresented: $showModal, content: {
            addBankAccount()
        })
        
        .onAppear{
            userManagement.getAccountInfo(){result in
                guard let result = result else{return}
            }
        }
        
        .fullScreenCover(isPresented: $showSignIn, content: {
            SignInView(helper : UserManagement())
        })
        
        .alert(isPresented: $showAlert){
            switch alertType{
            case .update:
                return Alert(title: Text("계좌 정보 업데이트"),
                             message: Text("계좌 정보를 업데이트할까요?"),
                             primaryButton: .default(Text("예")){
                                
                             }, secondaryButton: .default(Text("아니오")){
                                
                             })
            case .none:
                break
            case .some(.remove):
                return Alert(title: Text("계좌 정보 제거"),
                             message: Text("계좌 정보를 제거할까요?\n제거 후에는 복구가 불가능합니다."),
                             primaryButton: .default(Text("예")){
                                
                             }, secondaryButton: .default(Text("아니오")){
                                
                             })
                
            case .some(.done_remove):
                return Alert(title: Text("제거 완료"),
                             message: Text("계좌 정보를 제거했습니다."),
                             dismissButton: .default(Text("확인")))
                
            case .some(.error_update):
                return Alert(title: Text("업데이트 오류"),
                             message: Text("계좌 정보를 업데이트 하는 중 오류가 발생했습니다.\n네트워크 상태를 확인하거나, 나중에 다시 시도하십시오."),
                             dismissButton: .default(Text("확인")))
                
            case .some(.done_update):
                return Alert(title: Text("업데이트 완료"),
                             message: Text("계좌 정보를 업데이트했습니다."),
                             dismissButton: .default(Text("확인")))
                
            case .some(.error_remove):
                return Alert(title: Text("제거 오류"),
                             message: Text("계좌 정보를 제거 하는 중 오류가 발생했습니다.\n네트워크 상태를 확인하거나, 나중에 다시 시도하십시오."),
                             dismissButton: .default(Text("확인")))
                
            case .some(.noUser):
                return Alert(title: Text("사용자 정보 없음"),
                             message: Text("사용자 정보가 없습니다.\n확인 버튼을 누르면 로그인 페이지로 이동합니다."),
                             dismissButton: .default(Text("확인")){
                                self.showSignIn = true
                             })
                
            }
            
            return Alert(title: Text(""), dismissButton: .cancel())
        }

    }
}

struct ManageAccountView_Previews: PreviewProvider {
    static var previews: some View {
        ManageAccountView()
    }
}
