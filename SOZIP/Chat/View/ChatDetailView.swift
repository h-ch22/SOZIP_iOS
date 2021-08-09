//
//  ChatDetailView.swift
//  ChatDetailView
//
//  Created by 하창진 on 2021/08/04.
//

import SwiftUI
import MobileCoreServices

struct ChatDetailView: View {
    @ObservedObject var helper : ChatHelper
    @ObservedObject var mediaItems = ChatPickedMediaItems()
    @State private var typingMessage = ""
    @State private var tap = false
    @State private var scrolled = false
    @State private var scrollToBottom = false
    
    @State private var modalType : chatModalType? = nil
    @State private var showModal = false
    @State private var model : SOZIPDataModel? = nil
    @State private var showActionSheet = false
    @State private var mediaType : MediaType? = nil
    @State private var imgURL : [String?] = []
    @State private var docId = ""
    @State private var showImgView = false
    @State private var docIndex = 0
    
    let rootDocId : String
    let name : String
    
    private func chatActionSheet() -> ActionSheet{
        let buttons = [
            ActionSheet.Button.default(Text("사진 찍기")){
                self.showActionSheet = false
                self.modalType = .camera
                self.showModal = true
            },
            
            ActionSheet.Button.default(Text("사진앱에서 사진 선택하기")){
                self.showActionSheet = false
                self.mediaType = .photo
                self.modalType = .photoLibrary
                self.showModal = true
            },
            
            ActionSheet.Button.cancel(Text("취소"))
        ]
        
        let actionSheet = ActionSheet(title : Text("컨텐츠 로드 방식 선택"),
                                      message: Text("원하시는 옵션을 선택하세요!"),
                                      buttons: buttons)
        
        return actionSheet
    }
    
    var body: some View {
        ZStack(alignment : .top) {
            Color.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack{
                ScrollView{
                    ScrollViewReader{ reader in
                        LazyVStack{
                            ForEach(helper.chatList, id : \.self){item in
                                messageView(items: item)
                                
                                    .onTapGesture(perform: {
                                        if item.type == "image"{
                                            print("launching image view..")
                                            self.docId = item.docId
                                            imgURL = item.items
                                            showImgView = true
                                            
                                        }
                                    })
                                
                                    .sheet(isPresented : $showImgView){
                                        ImageDetailView(imgURL: $imgURL, docRef : $docId, helper : ChatHelper())
                                            .navigationBarTitle("", displayMode: .inline)
                                    }
                                
                                
                                    .contextMenu(
                                        item.type == "text" ?
                                        ContextMenu{
                                            Button{
                                                    UIPasteboard.general.string = item.msg
                                            } label :{
                                                Label("복사", systemImage : "doc.on.clipboard")
                                            }
                                        } : nil)
                                
                                                    
                                Spacer().frame(height : 10)
                            }

                        }
                    }
                }
                
                HStack {
                    Button(action: {
                        self.showActionSheet = true
                    }){
                        Image(systemName: "camera.fill")
                            .resizable()
                            .frame(width : 25, height : 20)
                            .foregroundColor(.txt_color)
                    }
                    
                    Spacer().frame(width : 10)

                    TextField("메시지를 입력하세요.", text: $typingMessage)
                       .frame(minHeight: CGFloat(30))
                    
                    Button(action: {
                        self.tap = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                            self.tap = false
                        })
                        
                        if typingMessage != ""{
                            
                            helper.sendChat(rootDocId: self.rootDocId, msg: typingMessage){result in
                                guard let result = result else{return}
                                
                            }
                        }
                        
                        typingMessage = ""
                        
                    }) {
                         Image(systemName: "arrow.up")
                            .resizable().frame(width : 20, height : 20)
                            .padding(5)
                            .foregroundColor(.white)
                            .background(Circle().foregroundColor(self.typingMessage.isEmpty ? Color.gray : .accent))
                            .rotationEffect(Angle(degrees: tap ? 360.0 : 0.0))
                            .animation(tap ? Animation.linear(duration: 0.25) : nil)
                            
                    }
                    
                 }.frame(minHeight: CGFloat(50)).padding()
                    
            }.padding([.horizontal], 20)
            
        }.navigationBarTitle(Text(name), displayMode: .inline)
        .toolbar{
            ToolbarItemGroup(placement : .navigationBarTrailing){
                Button(action: {
                    modalType = .report
                    showModal = true
                }){
                    Image(systemName: "exclamationmark.bubble.fill").resizable().frame(width : 20, height : 20).foregroundColor(.red)
                }

                Button(action: {
                    modalType = .info
                    showModal = true
                }){
                    Image(systemName: "info.circle.fill").resizable().frame(width : 20, height : 20).foregroundColor(.txt_color)
                }
            }
        }
        .onAppear(perform: {
            helper.getChatContents(rootDocId: self.rootDocId){(result) in
                guard let result = result else{return}
            }
    })
    
        .sheet(isPresented : $showModal){
            switch modalType{
            case .info:
                EmptyView()
                
            case .report:
                EmptyView()
                
            case .none:
                EmptyView()

                
            case .photoLibrary:
                ChatPhotoPicker(mediaItems : mediaItems, isPresented: $showModal, mediaType: $mediaType, rootDocId : rootDocId, helper : helper)
                
            case .camera:
                ImagePickerView(sourceType: .camera){(image) in
                    let pickedImage : Image? = Image(uiImage: image)
                    
                    if pickedImage != nil{
                        helper.sendCapturedImage(rootDocId: rootDocId, image: pickedImage!)
                    }
                    
                }
            }
        }
        
        
    
        .actionSheet(isPresented: $showActionSheet, content: chatActionSheet)
    
                    
    }

}
