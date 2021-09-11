//
//  FeedbackHubMain.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/30.
//

import SwiftUI

struct FeedbackHubMain: View {
    @ObservedObject var helper : FeedbackHubHelper
    @StateObject private var userManagement = UserManagement()
    @Environment(\.presentationMode) var presentationMode

    @State private var navigateToSignIn = false
    @State private var category : FeedbackHubCategoryModel? = nil
    @State private var alertModel : FeedbackHubErrorModel?
    @State private var title = ""
    @State private var contents = ""
    @State private var showProcess = false
    @State private var containerHeight : CGFloat = 0.0
    @State private var isAdmin = false

    @State private var isTitleEditing = false
    
    var body: some View {
        KeyboardView{
            ScrollView{
                ZStack{
                    Color.backgroundColor.edgesIgnoringSafeArea(.all)
                    
                    VStack{
                        Spacer().frame(height : 40)
                        
                        Group{
                            Image("bg_feedbackHub")
                                .resizable()
                                .frame(width: 200, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            
                            Spacer().frame(height : 20)

                            Text("고객님의 소집은 어떠셨나요?")
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            
                            Spacer().frame(height : 20)

                            HStack{
                                Spacer()

                                Button(action:{
                                    self.category = .heart
                                }){
                                    Image(systemName: "heart.fill")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(self.category == .heart ? .white : .accent)
                                }.padding(30)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .foregroundColor(self.category == .heart ? .accent : .btn_color)
                                        .shadow(radius: 5)
                                )
                                
                                Spacer()
                                
                                Button(action:{
                                    self.category = .improve
                                }){
                                    Image(systemName: "chevron.right.2")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .rotationEffect(Angle(degrees: -90))
                                        .foregroundColor(self.category == .improve ? .white : .accent)
                                }.padding(30)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .foregroundColor(self.category == .improve ? .accent : .btn_color)
                                        .shadow(radius: 5)
                                )
                                
                                Spacer()

                                Button(action:{
                                    self.category = .question
                                }){
                                    Image(systemName: "questionmark.circle.fill")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(self.category == .question ? .white : .accent)
                                }.padding(30)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .foregroundColor(self.category == .question ? .accent : .btn_color)
                                        .shadow(radius: 5)
                                )

                                Spacer()

                            }
                        }

                        Spacer().frame(height : 40)

                        Group {
                            HStack {
                                Image("ic_roomName")
                                    .resizable()
                                    .frame(width : 20, height : 20)
                                
                                TextField("피드백 제목", text:$title, onEditingChanged: {(editing) in
                                    if editing{
                                        isTitleEditing = true
                                    }
                                    
                                    else{
                                        isTitleEditing = false
                                    }
                                })
                            }
                            .foregroundColor(isTitleEditing ? Color.accent : Color.txt_color)
                            .padding(20)
                            .padding([.horizontal], 30)
                            .background(RoundedRectangle(cornerRadius: 10)
                                            .foregroundColor(.btn_color)
                                            .shadow(radius: 5)
                                        .padding([.horizontal],20))
                        }
                        
                        Spacer().frame(height : 20)

                        AutoSizingTextField(hint: "고객님의 소집 경험을 들려주세요.", text: $contents, containerHeight: $containerHeight)
                            .padding(.horizontal)
                            .frame(height : containerHeight <= 120 ? containerHeight : 120)
                            .background(BlurView(style : .dark))
                            .clipShape(RoundedRectangle(cornerRadius: 25))

                        Spacer().frame(height : 40)

                        Button(action: {
                            
                            if category == nil{
                                self.alertModel = .noCategory
                            }
                            
                            else if title == "" || contents == ""{
                                self.alertModel = .noContents
                            }
                            
                            else{
                                showProcess = true
                                
                                helper.sendFeedback(category: category!, title: title, contents: contents){(result) in
                                    guard let result = result else{return}
                                    
                                    if result == .success{
                                        self.alertModel = .success
                                        showProcess = false
                                    }
                                    
                                    else if result == .error{
                                        self.alertModel = .error
                                        showProcess = false
                                    }
                                    
                                    else if result == .noUser{
                                        self.alertModel = .noUser
                                        showProcess = false
                                    }
                                    
                                    else{
                                        showProcess = false
                                    }
                                }
                            }
                            

                            
                        }){
                            HStack{
                                Text("피드백 보내기")
                                    .foregroundColor(.white)
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                            }.padding(20)
                            .padding([.horizontal], 100)
                            .background(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).shadow(radius: 5))
                            .disabled(title.isEmpty || contents.isEmpty || category == nil)
                        }
                        
                        Spacer().frame(height : 20)

                        NavigationLink(destination: sentFeedback()){
                            Text("보낸 피드백 확인하기")
                                .foregroundColor(.accent)
                        }
                    }
                }
            }.onAppear{
                userManagement.getAdminInfo(){result in
                    guard let result = result else{return}
                    
                    if result == "true"{
                        isAdmin = true
                    }
                    
                    else{
                        isAdmin = false
                    }
                }
            }
            .padding(20)
            .background(Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
            .navigationBarTitle(Text("피드백 허브"), displayMode: .inline)
            .navigationBarItems(trailing: isAdmin ? NavigationLink(destination: FeedbackHubManagerView()){
                Text("피드백 관리")
            } : nil)
            .alert(item : $alertModel){item in
                switch(item){
                case .success:
                    return Alert(title: Text("피드백 전송 완료"),
                                 message: Text("피드백이 정상적으로 전송되었습니다.\n보내주신 피드백은 내부에서 충분히 검토한 후 답변드리겠습니다.\n피드백을 보내주셔서 감사합니다."),
                                 dismissButton: .default(Text("확인")){
                                    self.title = ""
                                    self.contents = ""
                                    self.category = nil
                                    
                                    self.presentationMode.wrappedValue.dismiss()
                                 })
                    
                case .noUser:
                    return Alert(title: Text("로그인 오류"),
                                 message: Text("사용자 정보를 불러올 수 없습니다.\n로그인 화면으로 이동합니다."),
                                 dismissButton: .default(Text("확인")){self.navigateToSignIn = true})
                    
                case .error:
                    return Alert(title: Text("오류"),
                                 message: Text("피드백을 전송하는 중 오류가 발생했습니다.\n네트워크 상태를 확인하거나, 나중에 다시 시도하십시오."),
                                 dismissButton: .default(Text("확인")))
                    
                case .noContents:
                    return Alert(title: Text("공백 필드"),
                                 message: Text("모든 필드를 채워주세요."),
                                 dismissButton: .default(Text("확인")))
                    
                case .noCategory:
                    return Alert(title: Text("선택된 카테고리 없음"),
                                 message: Text("카테고리를 선택해주세요."),
                                 dismissButton: .default(Text("확인")))
                }
            }
            
            .fullScreenCover(isPresented: $navigateToSignIn, content: {
                SignInView(helper : UserManagement())
            })
            
            .overlay(ProcessView().isHidden(!showProcess))
            
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


    }
}

struct FeedbackHubMain_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackHubMain(helper: FeedbackHubHelper())
    }
}
