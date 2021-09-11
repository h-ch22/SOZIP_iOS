//
//  CounselorView_chat.swift
//  SOZIP
//
//  Created by 하창진 on 2021/09/10.
//

import SwiftUI

struct CounselorView_chat: View {
    @StateObject private var helper = CounselorHelper()
    @State private var counselorDocId : String = ""
    @State private var scrolled = false
    @State private var msg = ""
    @State private var animate = false
    @State private var containerHeight : CGFloat = 0.0
    
    let docId : String
    
    var body: some View {
        KeyboardView{
            ZStack {
                Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
                VStack{
                    if helper.isProcessing{
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                        
                        Spacer().frame(height : 10)
                        
                        Text("고객님의 상담 진행을 위해 데이터를 준비하고 있습니다.\n잠시 기다려주세요.")
                            .font(.caption)
                            .foregroundColor(.txt_color)
                            .multilineTextAlignment(.center)
                    }
                    
                    else{
                        ScrollViewReader{reader in
                            ScrollView{
                                ForEach(helper.chatContents, id : \.docId){index in
                                    CounselorChatRow(data : index)
                                        .onAppear{
                                            if index.docId == helper.chatContents.last!.docId && !scrolled{
                                                reader.scrollTo(helper.chatContents.last!.docId, anchor : .bottom)
                                            }
                                        }
                                        
                                        .contextMenu{
                                            if index.msg_type == "text"{
                                                Button{
                                                    UIPasteboard.general.string = index.msg ?? ""
                                                } label : {
                                                    Label("복사", systemImage : "doc.on.clipboard")
                                                }
                                            }
                                        }
                                    
                                    Spacer().frame(height : 15)
                                    
                                }
                                
                                
                                
                            }
                        }
                        .padding([.horizontal], 20)
                        .padding([.vertical], 10)
                        .animation(.easeOut)
                        
                        HStack(spacing : 10){
                            AutoSizingTextField(hint: "메시지를 입력하세요.", text: $msg, containerHeight: $containerHeight)
                                .padding(.horizontal)
                                .frame(height : containerHeight <= 120 ? containerHeight : 120)
                                .background(BlurView(style : .dark))
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                            
                            Button(action : {
                                self.animate = true
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                                    self.animate = false
                                })
                                
                                if msg != ""{
                                    helper.sendPlainText(msg: msg, docId: counselorDocId){result in
                                        guard let result = result else{return}
                                        
                                        if result == "success"{
                                            msg = ""
                                        }
                                    }
                                }
                                
                            }){
                                Image(systemName: "arrow.up")
                                    .foregroundColor(.white)
                                    .frame(width : 30, height : 30)
                                    .rotationEffect(Angle(degrees: animate ? 360.0 : 0.0))
                                    .animation(animate ? Animation.linear(duration: 0.25) : nil)
                                    .background(self.msg == "" ? Color.gray : Color.accent)
                                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                
                            }
                        }.padding()
                        
                    }
                }
                
            }.onAppear{
                helper.prepare_chat(docId: docId){result in
                    guard let result = result else{return}
                    
                    if result != "" && result != "error"{
                        counselorDocId = result
                        
                        helper.getChatList(docId : counselorDocId){result in
                            guard let result = result else{return}
                        }
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
        
    }
}
