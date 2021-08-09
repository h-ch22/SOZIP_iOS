//
//  addSozipView.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/29.
//

import SwiftUI
import NMapsMap

struct addSozipView: View {
    @State private var roomName = ""
    @State private var location = ""
    @State private var latLng : NMGLatLng? = nil
    @State private var hash : [String] = []
    @State private var colorCode : Color = .sozip_bg_1
    
    @State private var isRoomNameEditing = false
    @State private var isStoreEditing = false
    @State private var isLocationEditing = false
    @State private var selectedDate = Date()
    
    @State private var showTag = false
    @State private var showAlert = false
    @State private var alertModel : addSOZIPResultModel?
    @State private var isProcessing = false
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var receiver : SOZIPLocationReceiver
    
    let helper = SOZIPHelper()

    let dateFormattr : DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .short
        
        return df
    }()
    
    var body: some View {
        NavigationView{
            ScrollView{
                ZStack {
                    Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    
                    VStack{
                        HStack{
                            Text("아래 정보를 입력해주세요.")
                                .fontWeight(.bold)
                            
                            Spacer()
                        }
                        
                        Group {
                            Spacer().frame(height : 40)
                            
                            HStack {
                                HStack {
                                    Image("ic_roomName")
                                        .resizable()
                                        .frame(width : 20, height : 20)
                                    
                                    TextField("메뉴명", text:$roomName, onEditingChanged: {(editing) in
                                        if editing{
                                            isRoomNameEditing = true
                                        }
                                        
                                        else{
                                            isRoomNameEditing = false
                                        }
                                    })
                                    
                                    
                                }
                                .foregroundColor(isRoomNameEditing ? Color.accent : Color.txt_color)
                                .padding(20)
                                .padding([.horizontal], 50)
                                .background(RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(.btn_color)
                                                .shadow(radius: 5)
                                                .padding([.horizontal],30))
                                
                                Text("드실 분!")
                                    .foregroundColor(.txt_color)
                            }
                                                        
                            Spacer().frame(height : 20)
                        }
                        
                        Group{
                            NavigationLink(destination : NavigateToMapViewController(receiver : receiver)
                                            .navigationBarTitle(Text("소집 장소 선택하기"),
                                                                displayMode: .inline)
                                            .accentColor(.accent)
                            ){
                                VStack {
                                    HStack {
                                        Image(systemName: "location.fill.viewfinder")
                                            .resizable()
                                            .frame(width : 20, height : 20)
                                        
                                        Text(receiver.location.isEmpty ? "소집 장소" : receiver.address + "\n" + receiver.description)
                                        
                                    }
                                    
                                    if !receiver.location.isEmpty{
                                        Text("다시 설정하려면 누르세요.")
                                            .font(.caption)
                                            .foregroundColor(.white)
                                    }
                                    
                                }.foregroundColor(receiver.location.isEmpty ? Color.txt_color : Color.white)
                                .padding(20)
                                .padding([.horizontal], 30)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(receiver.location.isEmpty ? .btn_color : .accent)
                                        .shadow(radius: 5)
                                    .padding([.horizontal],20))
                            }
                            
                            Spacer().frame(height : 20)
                            
                            Button(action : {
                            }){
                                VStack {
                                    HStack{
                                        Image(systemName : "clock.fill")
                                            .resizable()
                                            .frame(width : 20, height : 20)
                                        
                                        Text("마감 날짜 및 시간")
                                        
                                    }
                                    
                                    DatePicker("", selection : $selectedDate, in: Date()...)
                                        .labelsHidden()
                                }
                            }.foregroundColor(Color.txt_color)
                            .padding(20)
                            .padding([.horizontal], 45)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.btn_color).shadow(radius: 5)
                                        .padding([.horizontal],15))
                            
                            Spacer().frame(height : 20)
                            
                            Button(action: {
                                self.showTag = true
                            }){
                                HStack {
                                    Image("ic_hashtag")
                                        .resizable()
                                        .frame(width : 20, height : 20)
                                    
                                    if self.hash.isEmpty{
                                        Text("해시태그")
                                    }
                                    
                                    else{
                                        ForEach(hash.indices){
                                            Text(self.hash[$0] + "")
                                        }
                                    }
                                }.foregroundColor(self.hash.isEmpty ? Color.txt_color : Color.accent)
                                .padding(20)
                                .padding([.horizontal], 105)
                                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.btn_color).shadow(radius: 5)
                                            .padding([.horizontal],15))
                            }
                        }
                        
                        Spacer().frame(height : 40)
                        
                        Button(action: {
                            if self.roomName.isEmpty || receiver.location.isEmpty || self.selectedDate == nil{
                                alertModel = .emptyField
                                showAlert = true
                            }
                            
                            else{
                                isProcessing = true

                                helper.addSOZIP(name: self.roomName + " 드실 분!",
                                                receiver: self.receiver,
                                                dateTime: self.selectedDate,
                                                tags: self.hash){result in
                                    
                                    guard let result = result else{return}
                                    
                                    if result{
                                        isProcessing = false
                                        alertModel = .success
                                        showAlert = true
                                    }
                                    
                                    else{
                                        isProcessing = false
                                        alertModel = .error
                                        showAlert = true
                                    }
                                }
                            }
                        }){
                            HStack{
                                Text("소집 만들기")
                                    .foregroundColor(.white)
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                            }.padding(20)
                            .padding([.horizontal], 60)
                            .background(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).shadow(radius: 5))
                            .disabled(self.roomName.isEmpty || receiver.location.isEmpty || self.selectedDate == nil)
                            
                        }
                    }
                }
            }.navigationBarTitle(Text("소집 만들기"))
            .navigationBarItems(trailing: Button("닫기"){self.presentationMode.wrappedValue.dismiss()})
            .padding(20)
            .background(Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
            .sheet(isPresented: $showTag, content: {
                selectTag(helper : TagManager())
            })
            .accentColor(.accent)
            
            .alert(isPresented : $showAlert){
                switch(alertModel){
                case .success:
                    return Alert(title : Text("업로드 완료"),
                                 message : Text("소집이 추가되었어요!"),
                                 dismissButton : .default(Text("확인")){
                                    self.presentationMode.wrappedValue.dismiss()
                                 })
                    
                case .error :
                    return Alert(title : Text("오류"),
                                 message : Text("소집을 추가하는 중 문제가 발생했습니다.\n네트워크 상태를 확인하거나, 나중에 다시 시도해주세요."),
                                 primaryButton: .default(Text("피드백허브")){
                                    
                                 },
                                 secondaryButton: .default(Text("확인")))
                    
                case .emptyField :
                    return Alert(title : Text("공백 필드"),
                                 message : Text("모든 필드를 입력해주세요."),
                                 dismissButton : .default(Text("확인")))
                case .none:
                    return Alert(title: Text(""),
                                 message: Text(""),
                                 dismissButton: .default(Text("확인")))
                }
            }
            
            .overlay(
                ProcessView()
                    .isHidden(!isProcessing)
            )
        }
    }
}

struct addSozipView_Previews: PreviewProvider {
    static var previews: some View {
        addSozipView(receiver: SOZIPLocationReceiver())
    }
}
