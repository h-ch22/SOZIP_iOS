//
//  ChatDetailView.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/25.
//

import SwiftUI
import SwiftUITooltip
import Firebase

struct ChatDetailView: View {
    let SOZIPData : ChatListDataModel
    let SOZIPHelper : SOZIPHelper
    let SOZIPInfo : SOZIPDataModel
        
    @State var chatData : [ChatDataModel] = []
    @StateObject var helper = ChatHelper()
    
    @State private var animate = false
    @State private var msg = ""
    @State private var containerHeight : CGFloat = 0.0
    @State private var offset : CGFloat = 0
    @State private var lastOffset : CGFloat = 0
    @State private var endTutorial = false
    @State private var scrolled = false
    
    @State private var showSOZIPDetailView = false
    @State private var showCamera = false
    @State private var pickedImage : Image?
    @State private var showOverlay = false
    @State private var showPhotoPicker = false
    @State private var showAccountPicker = false
    @State private var showDutchPayView = false

    
    @GestureState private var gestureOffset : CGFloat = 0
    
    @ObservedObject var mediaItems = ChatPickedMediaItems()
    
    var tooltipConfig = DefaultTooltipConfig()
    
    func onChange(){
        DispatchQueue.main.async{
            self.offset = gestureOffset + lastOffset
        }
    }
    
    func getBlurRadius() -> CGFloat{
        let progress = -offset / (UIScreen.main.bounds.height - 100)
        
        return progress
    }
    
    var body: some View {
        ZStack {
            Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            GeometryReader{proxy in
                VStack {
                    ScrollViewReader{reader in
                        ScrollView{
                            VStack{
                                ForEach(helper.chatContents, id : \.docId){index in
                                    ChatContentsRow(data: index, SOZIPData: SOZIPData, account : SOZIPInfo.account)
                                        .onAppear{
                                            if index.docId == helper.chatContents.last!.docId && !scrolled{
                                                reader.scrollTo(helper.chatContents.last!.docId, anchor : .bottom)
                                            }
                                        }
                                        
                                        
                                        .contextMenu{
                                            if index.type == "text"{
                                                Button{
                                                    UIPasteboard.general.string = AES256Util.decrypt(encoded: index.msg)
                                                } label : {
                                                    Label("복사", systemImage : "doc.on.clipboard")
                                                }
                                            }
                                            
                                            else if index.type == "account"{
                                                Button{
                                                    let acc = SOZIPInfo.account
                                                    let accountInf = acc.components(separatedBy: " ")
                                                    
                                                    let bank = AES256Util.decrypt(encoded: accountInf[0])
                                                    let accountNumber = AES256Util.decrypt(encoded: accountInf[1])
                                                    
                                                    UIPasteboard.general.string = bank + " " + accountNumber
                                                    
                                                } label : {
                                                    Label("계좌번호 복사", systemImage : "doc.on.clipboard")
                                                }
                                            }
                                            
                                            
                                            
                                        }
                                    
                                    
                                    if index.type == "participate"{
                                        if SOZIPInfo.url != nil && SOZIPInfo.url != "" && SOZIPInfo.url != "about:blank"{
                                            Spacer().frame(height : 10)
                                            
                                            Button(action : {
                                                if let url = URL(string : SOZIPInfo.url!){
                                                    UIApplication.shared.open(url)
                                                }
                                            }){
                                                HStack{
                                                    Image(systemName : "link.circle.fill")
                                                        .font(.title)
                                                        .foregroundColor(.txt_color)
                                                        .frame(width : 25, height : 25)
                                                    
                                                    Text("소집 개설자가 추가한 메뉴 확인하기")
                                                        .font(.caption)
                                                        .foregroundColor(.txt_color)
                                                    
                                                    Spacer()
                                                    
                                                    Image(systemName : "chevron.right.circle.fill")
                                                        .font(.title)
                                                        .foregroundColor(.txt_color)
                                                        .frame(width : 25, height : 25)
                                                }.padding(20).background(RoundedRectangle(cornerRadius: 15.0).shadow(radius: 2).foregroundColor(.btn_color))
                                                
                                                
                                            }
                                            
                                        }
                                    }
                                    
                                    Spacer().frame(height : 15)
                                }
                            }.onChange(of: helper.chatContents, perform: { value in
                                reader.scrollTo(helper.chatContents.last!.docId, anchor : .bottom)
                            })
                            
                        }.blur(radius: getBlurRadius())
                        
                    }
                    
                }.padding(.horizontal, 20)
                .frame(height : proxy.size.height - 100)
                .animation(.easeOut)
            }
            
            KeyboardView{
                GeometryReader{proxy -> AnyView in
                    let height = proxy.frame(in: .global).height
                    
                    return AnyView(
                        ZStack{
                            BlurView(style : .systemThinMaterialDark)
                                .clipShape(CustomCorner(corners : [.topLeft, .topRight], radius : 30))
                            
                            VStack{
                                Capsule()
                                    .fill(Color.white)
                                    .frame(width : 60, height : 4)
                                    .padding(.top)
                                    .tooltip(.top, config : tooltipConfig){
                                        Text("자세한 내용을 확인하려면 위로 올리세요!")
                                    }
                                
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
                                            helper.sendPlainText(rootDocId: SOZIPData.docId, msg: msg){result in
                                                guard let result = result else{return}
                                                
                                                if result == "success"{
                                                    msg = ""
                                                    self.offset = 0
                                                    self.lastOffset = 0
                                                }
                                                
                                                else{
                                                    
                                                }
                                            }
                                        }
                                        
                                    }){
                                        Image(systemName: "arrow.up")
                                            .foregroundColor(.white)
                                            .frame(width : 30, height : 30)
                                            .rotationEffect(Angle(degrees: animate ? 360.0 : 0.0))
                                            .animation(animate ? Animation.linear(duration: 0.25) : nil)
                                            .background(self.msg == "" ? Color.gray : SOZIPData.color)
                                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                        
                                    }
                                }.padding()
                                
                                ScrollView{
                                    VStack{
                                        HStack(spacing : 15) {
                                            Text("채팅 메뉴")
                                                .fontWeight(.semibold)
                                                .foregroundColor(.white)
                                            
                                            Spacer()
                                        }
                                        .padding(20)
                                        
                                        Divider()
                                            .background(Color.white)
                                        
                                        ScrollView(.horizontal){
                                            HStack(spacing : 15){
                                                Button(action: {
                                                    self.showCamera = true
                                                }){
                                                    VStack{
                                                        Image(systemName : "camera.fill")
                                                            .font(.title)
                                                            .foregroundColor(.blue)
                                                            .frame(width : 55, height : 55)
                                                            .background(BlurView(style: .dark))
                                                            .clipShape(Circle())
                                                        
                                                        Spacer().frame(height : 5)
                                                        
                                                        Text("사진 촬영")
                                                            .font(.caption)
                                                            .foregroundColor(.white)
                                                    }
                                                }
                                                
                                                Button(action: {
                                                    showPhotoPicker = true
                                                }){
                                                    VStack{
                                                        Image(systemName : "photo.on.rectangle.fill")
                                                            .font(.title)
                                                            .foregroundColor(.blue)
                                                            .frame(width : 55, height : 55)
                                                            .background(BlurView(style: .dark))
                                                            .clipShape(Circle())
                                                        
                                                        Spacer().frame(height : 5)
                                                        
                                                        Text("이미지 선택")
                                                            .font(.caption)
                                                            .foregroundColor(.white)
                                                    }
                                                }
                                                
                                                if SOZIPInfo.url != nil && SOZIPInfo.url != "" && SOZIPInfo.url != "about:blank"{
                                                    Button(action : {
                                                        if let url = URL(string : SOZIPInfo.url!){
                                                            UIApplication.shared.open(url)
                                                        }
                                                    }){
                                                        VStack{
                                                            Image(systemName : "link.circle.fill")
                                                                .font(.title)
                                                                .foregroundColor(.blue)
                                                                .frame(width : 55, height : 55)
                                                                .background(BlurView(style: .dark))
                                                                .clipShape(Circle())
                                                            
                                                            Spacer().frame(height : 5)
                                                            
                                                            Text("메뉴 보기")
                                                                .font(.caption)
                                                                .foregroundColor(.white)
                                                        }
                                                    }
                                                    
                                                }
                                                
                                                
                                                Button(action: {
//                                                    var account : String? = nil
//
//                                                    if Auth.auth().currentUser?.uid ?? "" != SOZIPData.Manager{
//                                                        self.showAccountPicker = true
//
//                                                        self.offset = 0
//                                                        self.lastOffset = 0
//                                                    }
//
//                                                    else{
//                                                        helper.sendAccount(rootDocId: SOZIPData.docId, account : account){(result) in
//                                                            guard let result = result else{return}
//
//                                                            if result == "success"{
//                                                                self.offset = 0
//                                                                self.lastOffset = 0
//                                                            }
//                                                        }
//                                                    }
                                                    
                                                    showDutchPayView = true
                                                    
                                                    
                                                }){
                                                    VStack{
                                                        Image(systemName : "wonsign.circle.fill")
                                                            .font(.title)
                                                            .foregroundColor(.accentColor)
                                                            .frame(width : 55, height : 55)
                                                            .background(BlurView(style: .dark))
                                                            .clipShape(Circle())
                                                        
                                                        Spacer().frame(height : 5)
                                                        
                                                        Text("계좌 정보 전송")
                                                            .font(.caption)
                                                            .foregroundColor(.white)
                                                    }
                                                }
                                                
                                                Button(action: {
                                                    
                                                    
                                                }){
                                                    VStack{
                                                        Image(systemName : "checkmark")
                                                            .font(.title)
                                                            .foregroundColor(.green)
                                                            .frame(width : 55, height : 55)
                                                            .background(BlurView(style: .dark))
                                                            .clipShape(Circle())
                                                        
                                                        Spacer().frame(height : 5)
                                                        
                                                        Text("소집 완료")
                                                            .font(.caption)
                                                            .foregroundColor(.white)
                                                    }
                                                }.isHidden(SOZIPInfo.Manager != Auth.auth().currentUser?.uid ?? "")
                                                
                                                Button(action: {
                                                    
                                                    
                                                }){
                                                    VStack{
                                                        Image(systemName : "xmark")
                                                            .font(.title)
                                                            .foregroundColor(.red)
                                                            .frame(width : 55, height : 55)
                                                            .background(BlurView(style: .dark))
                                                            .clipShape(Circle())
                                                        
                                                        Spacer().frame(height : 5)
                                                        
                                                        Text("소집 취소")
                                                            .font(.caption)
                                                            .foregroundColor(.white)
                                                    }
                                                }.isHidden(SOZIPInfo.Manager != Auth.auth().currentUser?.uid ?? "")
                                                
                                                Button(action: {
                                                    
                                                }){
                                                    VStack{
                                                        Image(systemName : "exclamationmark.bubble.fill")
                                                            .font(.title)
                                                            .foregroundColor(.red)
                                                            .frame(width : 55, height : 55)
                                                            .background(BlurView(style: .dark))
                                                            .clipShape(Circle())
                                                        
                                                        Spacer().frame(height : 5)
                                                        
                                                        Text("소집 신고")
                                                            .font(.caption)
                                                            .foregroundColor(.white)
                                                    }
                                                }
                                                
                                                Spacer()
                                            }.padding(20)
                                        }
                                        
                                        HStack(spacing : 15) {
                                            Text("소집 정보")
                                                .fontWeight(.semibold)
                                                .foregroundColor(.white)
                                            
                                            Spacer()
                                            
                                            Button(action : {
                                                self.showSOZIPDetailView = true
                                            }){
                                                Text("자세히")
                                                    .font(.caption)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(.gray)
                                            }
                                            
                                        }
                                        .padding(20)
                                        
                                        Divider()
                                            .background(Color.white)
                                        
                                        Spacer().frame(height : 15)
                                        
                                        if SOZIPInfo != nil{
                                            showMapView(data: SOZIPInfo)
                                                .frame(width : UIScreen.main.bounds.width / 1.2, height : UIScreen.main.bounds.height / 3)
                                                .shadow(radius: 5)
                                            
                                            Spacer().frame(height : 15)
                                            
                                            SOZIPManagerView(model: SOZIPInfo)
                                                .padding([.horizontal], 20)
                                        }
                                        
                                    }
                                }
                                
                                
                                
                            }.frame(maxHeight : .infinity, alignment: .top)
                        }.offset(y: height - 100)
                        .offset(y : -offset > 0 ? -offset <= (height - 100) ? offset : -(height - 100) : 0)
                        .gesture(DragGesture().updating($gestureOffset, body: {
                            value, out, _ in
                            
                            out = value.translation.height
                            onChange()
                        }).onEnded({value in
                            let maxHeight = height - 100
                            
                            endTutorial = true
                            
                            withAnimation{
                                if -offset > 100 && -offset < maxHeight / 2 {
                                    offset = -(maxHeight / 3)
                                }
                                
                                else if -offset > maxHeight / 2{
                                    offset = -maxHeight
                                }
                                
                                else{
                                    offset = 0
                                }
                            }
                            
                            lastOffset = offset
                        }))
                    )
                }.ignoresSafeArea(.all, edges: .bottom)
                
                
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
            
        }.onAppear(perform: {
            helper.getChatContents(data: SOZIPData){result in
                guard let result = result else{return}
            }
        })
        
        .sheet(isPresented: $showSOZIPDetailView, content: {
            NavigationView{
                VStack{
                    SOZIPDetailView(sozip: SOZIPInfo, helper: SOZIP.SOZIPHelper())
                }.navigationBarTitle(SOZIPInfo.SOZIPName, displayMode: .inline)
                .navigationBarItems(trailing: Button("닫기"){
                    self.showSOZIPDetailView = false
                })
            }
            
        })
        .sheet(isPresented : $showDutchPayView, content : {
            DutchPayView(data: SOZIPInfo)
        })
        
        .sheet(isPresented: $showCamera, content: {
            ChatCaptureView(sourceType: .camera){(image) in
                showOverlay = true
                
                self.pickedImage = Image(uiImage: image)
                
                if image != nil{
                    helper.sendSingleImage(rootDocId: SOZIPData.docId, image: image.pngData()){result in
                        guard let result = result else{return}
                        
                        showOverlay = false
                    }
                }
                
                else{
                    showOverlay = false
                }
                
            }
        })
        
        
        .sheet(isPresented : $showPhotoPicker, content : {
            ChatPhotoPicker(isPresented : $showPhotoPicker, mediaItems: mediaItems){didSelectItems in
                showPhotoPicker = false
                
                if didSelectItems && !mediaItems.items.isEmpty{
                    showOverlay = true
                    
                    helper.sendMultipleImages(image: mediaItems.items, rootDocId: SOZIPData.docId){result in
                        guard let result = result else{return}
                        
                        showOverlay = false
                    }
                }
                
                else{
                    print(didSelectItems)
                    print("is Empty : \(mediaItems.items.isEmpty)")
                }
            }
        })
        
        .sheet(isPresented : $showAccountPicker, content : {
            AccountPicker(isPresented : $showAccountPicker, rootDocId : SOZIPData.docId)
        })
        
        .navigationBarTitle(SOZIPData.SOZIPName, displayMode: .inline)
        .overlay(
            ProcessView()
                .isHidden(!showOverlay)
        )
    }
}
