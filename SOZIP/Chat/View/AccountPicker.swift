//
//  AccountPicker.swift
//  SOZIP
//
//  Created by 하창진 on 2021/09/09.
//

import SwiftUI
import SwiftUIPager

struct AccountPicker: View {
    @StateObject private var userManagement = UserManagement()
    @StateObject private var helper = ChatHelper()
    @State private var showAddAccountView = false
    @State private var showOverlay = false
    @State private var page : Page = Page.first()
    @State private var alertModel : sendAccountModel? = nil
    @State private var showAlert = false

    @Binding var isPresented : Bool
    
    let rootDocId : String
    
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
        NavigationView{
            ZStack {
                Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
                VStack{
                    Spacer().frame(height : 20)
                    
                    if userManagement.accounts.isEmpty{
                        Spacer()
                        
                        Text("아직 추가된 계좌가 없어요.")
                            .foregroundColor(.gray)
                        
                        Spacer().frame(height : 20)
                        
                        Button(action: {
                            self.showAddAccountView.toggle()
                        }){
                            Text("계좌 추가하기")
                        }
                        
                        Spacer()
                    }
                    
                    else{
                        Text("전송할 계좌 정보를 선택해주세요!")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.txt_color)
                        
                        Spacer().frame(height : 20)

                        Pager(page : page,
                              data : userManagement.accounts.indices,
                              id : \.self){
                            accountView($0)
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
                        .frame(height : 150)
                        
                        Spacer().frame(height : 20)

                        Button(action: {
                            let account : String? = "\(userManagement.accounts[page.index].bank) \(userManagement.accounts[page.index].accountNumber) \(userManagement.accounts[page.index].name)"
                            
                            helper.sendAccount(rootDocId: rootDocId, account: account ?? nil){ result in
                                guard let result = result else{return}
                                
                                if result == "success"{
                                    alertModel = .success
                                    showAlert = true
                                }
                                
                                else{
                                    alertModel = .fail
                                    showAlert = true
                                }
                            }
                        }){
                            HStack{
                                Text("계좌 정보 전송하기")
                                    .foregroundColor(.white)
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                            }.padding(20)
                            .frame(width : 300)
                            .background(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).shadow(radius: 5))
                        }
                    }
                }
            }
            .background(Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
            .navigationBarTitle(Text("계좌 정보 전송"), displayMode: .inline)
            .navigationBarItems(trailing: Button("닫기"){
                self.isPresented.toggle()
            })
            
            .sheet(isPresented: $showAddAccountView, content: {
                addBankAccount()
            })
            
            .alert(isPresented: $showAlert, content: {
                switch alertModel{
                case .success:
                    return Alert(title: Text("전송 완료"), message: Text("계좌 정보를 전송했어요."), dismissButton: .default(Text("확인")){self.isPresented.toggle()})
                    
                case .none:
                    return Alert(title: Text(""), message: Text(""), dismissButton: .default(Text("")))

                case .some(.fail):
                    return Alert(title: Text("오류"), message: Text("계좌 정보를 전송하는 중 문제가 발생했습니다.\n네트워크 상태를 확인하거나, 나중에 다시 시도하세요."), dismissButton: .default(Text("확인")))

                }
            })
            
            .onAppear{
                userManagement.getAccountInfo(){result in
                    guard let result = result else{return}
                }
            }
            
            .overlay(ProgressView().isHidden(!showOverlay))
        }
    }
}
//
//struct AccountPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        AccountPicker(isPresented: .constant(true))
//            .preferredColorScheme(.dark)
//    }
//}
