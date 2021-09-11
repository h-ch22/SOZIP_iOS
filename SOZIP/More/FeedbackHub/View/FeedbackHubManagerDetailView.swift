//
//  FeedbackHubManagerDetailView.swift
//  SOZIP
//
//  Created by 하창진 on 2021/09/10.
//

import SwiftUI

struct FeedbackHubManagerDetailView: View {
    let data : FeedbackHubItemModel
    
    @State private var alertModel : FeedbackHubManagerModel? = nil
    @State private var showAlert = false
    @State private var isAdmin : Bool? = nil
    @State private var answer = ""
    @State private var containerHeight : CGFloat = 0.0
    @State private var showOverlay = false
    
    @StateObject private var userManagement = UserManagement()
    @StateObject private var helper = FeedbackHubHelper()
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        KeyboardView{
            ZStack{
                Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
                if isAdmin != nil && isAdmin! == true{
                    VStack{
                        Spacer().frame(height : 15)
                        
                        HStack{
                            Text(data.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.txt_color)
                            
                            Spacer()
                        }
                        
                        Spacer().frame(height : 5)
                        
                        HStack{
                            Text(data.date)
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            switch (data.category){
                            case "칭찬해요":
                                Image(systemName: "heart.fill")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                Text("칭찬해요")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                                
                            case "개선해주세요":
                                Image(systemName: "chevron.right.2")
                                    .rotationEffect(Angle(degrees: -90))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                Text("개선해주세요")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                                
                            case "궁금해요" :
                                Image(systemName: "questionmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                                
                                Text("궁금해요")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                                
                            default :
                                EmptyView()
                            }
                        }
                        
                        Divider()
                        
                        ScrollView{
                            VStack{
                                HStack{
                                    Text(data.contents)
                                        .foregroundColor(.txt_color)
                                        .lineSpacing(/*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/)
                                        .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                    
                                    Spacer()
                                }
                            }
                            
                            Spacer().frame(height : 15)
                            
                            if data.answer == ""{
                                Text("아직 이 피드백에 대한 답변이 등록되지 않았습니다.")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .foregroundColor(.gray)
                            }
                            
                            else{
                                VStack{
                                    Text("피드백에 대한 답변입니다.")
                                        .fontWeight(.semibold)
                                    
                                    Spacer().frame(height : 10)
                                    
                                    Text(data.answer!)
                                        .foregroundColor(.txt_color)
                                        .lineSpacing(/*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/)
                                        .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                }.padding(20).background(RoundedRectangle(cornerRadius: 15.0).shadow(radius: 5).foregroundColor(.btn_color))
                            }
                            
                            Spacer().frame(height : 20)
                            
                            AutoSizingTextField(hint: "피드백의 답변을 입력하세요.", text: $answer, containerHeight: $containerHeight)
                                .padding(.horizontal)
                                .frame(height : containerHeight <= 120 ? containerHeight : 120)
                                .background(BlurView(style : .dark))
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                            
                            Spacer().frame(height : 20)
                            
                            Button(action: {
                                if answer.isEmpty{
                                    self.alertModel = .blankField
                                    showAlert = true
                                }
                                
                                else if answer == data.answer{
                                    self.alertModel = .same_answer
                                    showAlert = true
                                }
                                
                                else{
                                    if data.answer != ""{
                                        self.alertModel = .edit_answer
                                        showAlert = true
                                    }
                                    
                                    else{
                                        self.alertModel = .write_answer
                                        showAlert = true
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
                                .disabled(answer.isEmpty || answer == data.answer)
                            }
                        }
                    }
                    
                    
                }
                
                else{
                    
                }
            }.padding([.horizontal], 20)
            .background(Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
            .navigationBarTitle(data.title, displayMode: .inline)
            
            .overlay(ProcessView().isHidden(!showOverlay))
            
            .onAppear{
                userManagement.getAdminInfo(){result in
                    guard let result = result else{
                        self.alertModel = .error
                        showAlert = true
                        return
                    }
                    
                    if result == "true"{
                        self.isAdmin = true
                    }
                    
                    else if result == "false"{
                        self.alertModel = .noPermission
                        showAlert = true
                    }
                    
                    else{
                        self.alertModel = .error
                        showAlert = true
                    }
                }
            }
            
            .alert(isPresented: $showAlert, content: {
                switch alertModel{
                case .none:
                    return Alert(title: Text(""), message: Text(""), dismissButton: .default(Text("")))
                    
                case .some(.answer_uploaded):
                    return Alert(title: Text("업로드 완료"), message: Text("답변이 등록되었습니다."), dismissButton: .default(Text("확인")){
                        self.presentationMode.wrappedValue.dismiss()
                    })
                    
                case .some(.write_answer):
                    return Alert(title: Text("답변 등록"), message: Text("답변을 등록할까요?"), primaryButton: .default(Text("예")){
                        showOverlay = true
                        
                        helper.sendAnswer(answer: answer, docId: data.docId){result in
                            guard let result = result else{
                                alertModel = .answer_upload_fail
                                showAlert = true
                                
                                showOverlay = false
                                
                                return
                            }
                            
                            showOverlay = false
                            
                            if result == "success"{
                                alertModel = .answer_uploaded
                                showAlert = true
                            }
                            
                            else if result == "noPermission"{
                                alertModel = .noPermission
                                showAlert = true
                            }
                            
                            else if result == "fail"{
                                alertModel = .answer_upload_fail
                                showAlert = true
                            }
                            
                            else{
                                alertModel = .error
                                showAlert = true
                            }
                        }
                    }, secondaryButton: .default(Text("아니오")))
                case .some(.edit_answer):
                    return Alert(title: Text("답변 수정"), message: Text("이미 등록된 답변이 있습니다.\n내용을 수정하시겠습니까?"), primaryButton: .default(Text("예")){
                        showOverlay = true
                        
                        helper.sendAnswer(answer: answer, docId: data.docId){result in
                            guard let result = result else{
                                showOverlay = false
                                
                                alertModel = .answer_upload_fail
                                showAlert = true
                                
                                return
                            }
                            
                            showOverlay = false
                            
                            if result == "success"{
                                alertModel = .answer_uploaded
                                showAlert = true
                            }
                            
                            else if result == "noPermission"{
                                alertModel = .noPermission
                                showAlert = true
                            }
                            
                            else if result == "fail"{
                                alertModel = .answer_upload_fail
                                showAlert = true
                            }
                            
                            else{
                                alertModel = .error
                                showAlert = true
                            }
                        }
                    }, secondaryButton: .default(Text("아니오")))
                case .some(.answer_upload_fail):
                    return Alert(title: Text("업로드 오류"), message: Text("답변이 등록하는 중 오류가 발생했습니다.\n네트워크 상태를 확인하거나 나중에 다시 시도하십시오."), dismissButton: .default(Text("확인")))
                    
                case .some(.noPermission):
                    return Alert(title: Text("권한 없음"), message: Text("권한이 없습니다."), dismissButton: .default(Text("확인")){
                        self.presentationMode.wrappedValue.dismiss()
                    })
                    
                case .some(.error):
                    return Alert(title: Text("오류"), message: Text("오류가 발생했습니다.\n네트워크 상태를 확인하거나 나중에 다시 시도하십시오."), dismissButton: .default(Text("확인")))
                    
                case .some(.blankField):
                    return Alert(title: Text("답변 없음"), message: Text("피드백의 답변을 입력하십시오."), dismissButton: .default(Text("확인")))
                    
                case .some(.same_answer):
                    return Alert(title: Text("동일한 답변"), message: Text("등록된 답변과 동일한 답변입니다."), dismissButton: .default(Text("확인")){
                        self.answer = ""
                    })
                }
            })
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
