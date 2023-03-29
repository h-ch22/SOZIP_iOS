//
//  addSozipView.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/29.
//

import SwiftUI
import NMapsMap
import Firebase
import SwiftUIPager
import LinkPresentation

struct addSozipView: View {
    @State private var roomName = ""
    @State private var location = ""
    @State private var latLng : NMGLatLng? = nil
    @State private var url : String = ""
    @State private var hash : [String] = []
    @State private var colorCode : Color = .sozip_bg_1
    @State private var firstCome : Int = 4
    @State private var tags : [String] = ["한식", "분식", "카페/디저트", "돈까스/회/일식", "치킨", "피자", "아시안/양식", "중식", "족발/보쌈", "야식", "찜/탕", "도시락", "패스트푸드"]
    @State private var selectedTag = 0
    
    @State private var isRoomNameEditing = false
    @State private var isStoreEditing = false
    @State private var isLocationEditing = false
    @State private var isURLEditing = false
    @State private var selectedDate = Date()
    
    @State private var showAlert = false
    @State private var showTutorial = false
    
    @State private var alertModel : addSOZIPResultModel?
    @State private var isProcessing = false
    @State var redrawPreview = false
    
    @State private var page : Page = Page.first()
    @State private var categoryPage : Page = Page.first()
    
    @State private var showAddAccount = false
    
    @Binding var isShowing : Bool
    
    @ObservedObject var receiver : SOZIPLocationReceiver
    @StateObject var userManagement = UserManagement()
    
    let helper = SOZIPHelper()
    
    let dateFormattr : DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .short
        
        return df
    }()
    
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
    
    func categoryView(_ page : Int) -> some View{
        VStack{
            HStack{
                Spacer()
                
                Image(systemName : "checkmark.circle.fill")
                    .foregroundColor(.white)
                    .isHidden(self.categoryPage.index != page)
            }
            
            Text(tags[page])
                .foregroundColor(.white)
                .fontWeight(.semibold)
        }.padding(20)
        .background(RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(self.categoryPage.index == page ? .accent : .gray)
                        .shadow(radius: 5))
    }
    
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
                                    Image(systemName: "fork.knife.circle.fill")
                                        .resizable()
                                        .frame(width : 20, height : 20)
                                    
                                    TextField("식당명", text:$roomName, onEditingChanged: {(editing) in
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
                                .background(RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(.btn_color)
                                                .shadow(radius: 5))
                                
                                Text(" 시키실 분!")
                                    .foregroundColor(.txt_color)
                                
                            }.frame(width : 300)
                            
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
                                .frame(width : 300)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(receiver.location.isEmpty ? .btn_color : .accent)
                                        .shadow(radius: 5)
                                )
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
                            .frame(width : 300)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.btn_color).shadow(radius: 5))
                            
                            Spacer().frame(height : 20)
                            
                            HStack {
                                Image(systemName : "link.circle.fill")
                                    .resizable()
                                    .frame(width : 20, height : 20)
                                
                                TextField("배달앱 URL (선택)", text:$url, onEditingChanged: {(editing) in
                                    if editing{
                                        isURLEditing = true
                                    }
                                    
                                    else{
                                        isURLEditing = false
                                        
                                        let detector = try! NSDataDetector(types : NSTextCheckingResult.CheckingType.link.rawValue)
                                        
                                        let matches = detector.matches(in: url, options: [], range: NSRange(location: 0, length: url.utf16.count))
                                        
                                        for match in matches {
                                            guard let range = Range(match.range, in: url) else { continue }
                                            let url = url[range]
                                            self.url = String(url)
                                        }
                                        
                                        redrawPreview = true
                                    }
                                })
                                
                                if url == ""{
                                    Button(action : {
                                        self.showTutorial = true
                                    }){
                                        Image(systemName : "questionmark.circle.fill")
                                            .resizable()
                                            .frame(width : 20, height : 20)
                                            .foregroundColor(.gray)
                                    }
                                }
                                
                                else{
                                    Button(action : {self.url = ""}){
                                        Image(systemName : "xmark.circle.fill")
                                            .resizable()
                                            .frame(width : 20, height : 20)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            .foregroundColor(isURLEditing ? Color.accent : Color.txt_color)
                            .padding(20)
                            .background(RoundedRectangle(cornerRadius: 10)
                                            .foregroundColor(.btn_color)
                                            .shadow(radius: 5))
                            .frame(width : 300)
                            
                            if url != "" && !isURLEditing{
                                Spacer().frame(height : 20)
                                
                                LinkRow(previewURL : url, redraw : self.$redrawPreview)
                            }
                            
                            Spacer().frame(height : 20)
                            
                            
                        }

                        Group{
                            VStack{
                                Stepper(value: $firstCome, in: 1...4) {
                                    Text("소집 최대 참여 인원 : \(firstCome) 명")
                                }
                                
                                HStack {
                                    Text("고객님을 제외한 \(firstCome) 명의 소집 멤버가 참여하면 소집이 자동으로 종료됩니다.")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .fixedSize(horizontal : false, vertical : true)
                                    
                                    Spacer()
                                }
                                
                                Spacer().frame(height : 30)
                            }
                            
                            HStack{
                                Text("태그 선택")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.txt_color)
                                
                                Spacer()
                            }
                            
                            Spacer().frame(height : 5)
                            
                            HStack {
                                Text("소집 멤버들이 더 쉽게 소집을 찾을 수 있어요!")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                Spacer()
                            }
                            
                            ScrollView(.horizontal){
                                LazyHStack{
                                    ForEach(tags.indices, id: \.self){tag in
                                        Button(action: {
                                            self.selectedTag = tag
                                        }){
                                            Text(tags[tag])
                                                .foregroundColor(self.selectedTag == tag ? .white : .accent)
                                        }.padding(10)
                                        .padding([.horizontal], 10)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(self.selectedTag == tag ? .accent : .clear)
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius : 10)
                                                .stroke(lineWidth : 2)
                                                .foregroundColor(.accent)
                                                .isHidden(self.selectedTag == tag ? true : false)
                                        )
                                    }
                                }
                            }.padding()
                            .padding([.vertical], 10)
                            
                            Spacer().frame(height : 20)
                            
                        }
                        
                        Group{
                            HStack{
                                Text("정산 계좌")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.txt_color)
                                
                                Spacer()
                                
                                Button(action : {
                                    self.showAddAccount = true
                                }){
                                    Image(systemName : "plus.circle.fill")
                                        .foregroundColor(.accent)
                                    
                                }.isHidden(userManagement.accounts.isEmpty)
                            }
                            
                            Spacer().frame(height : 5)
                            
                            HStack {
                                Text("선택한 계좌 정보가 소집 멤버들에게 표시됩니다.")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                Spacer()
                            }
                            
                            Spacer().frame(height : 20)
                            
                            if userManagement.accounts.isEmpty{
                                Button(action: {
                                    showAddAccount = true
                                }){
                                    VStack{
                                        Image(systemName : "plus.circle.fill")
                                            .resizable()
                                            .frame(width : 30, height : 30)
                                            .foregroundColor(.white)
                                            .opacity(0.5)
                                        
                                        Text("계좌 추가")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                        
                                    }.frame(width : 180, height : 80)
                                    .padding(20)
                                    .background(RoundedRectangle(cornerRadius : 15).foregroundColor(.accent).shadow(radius: 5))
                                }
                            }
                            
                            else{
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
                                .frame(height : 150)
                                
                            }
                            
                        }
                        
                        Spacer().frame(height : 20)
                        
                        Group{
                            HStack{
                                Text("소집 색상")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.txt_color)
                                
                                Spacer()
                            }
                            
                            Spacer().frame(height : 5)
                            
                            HStack {
                                Text("선택한 색상이 목록과 채팅에 표시됩니다.")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                Spacer()
                            }
                            
                            Spacer().frame(height : 20)
                            
                            HStack{
                                Button(action : {
                                    self.colorCode = .sozip_bg_1
                                }){
                                    Circle()
                                        .foregroundColor(.sozip_bg_1)
                                        .shadow(radius : 5)
                                        .frame(width : 40, height : 40)
                                }.overlay(
                                    Image(systemName : "checkmark")
                                        .foregroundColor(.white)
                                        .isHidden(self.colorCode != .sozip_bg_1)
                                )
                                
                                Spacer().frame(height : 5)
                                
                                Button(action : {
                                    self.colorCode = .sozip_bg_2
                                }){
                                    Circle()
                                        .foregroundColor(.sozip_bg_2)
                                        .shadow(radius : 5)
                                        .frame(width : 40, height : 40)
                                }.overlay(
                                    Image(systemName : "checkmark")
                                        .foregroundColor(.white)
                                        .isHidden(self.colorCode != .sozip_bg_2)
                                )
                                
                                Spacer().frame(height : 5)
                                
                                Button(action : {
                                    self.colorCode = .sozip_bg_3
                                }){
                                    Circle()
                                        .foregroundColor(.sozip_bg_3)
                                        .shadow(radius : 5)
                                        .frame(width : 40, height : 40)
                                }.overlay(
                                    Image(systemName : "checkmark")
                                        .foregroundColor(.white)
                                        .isHidden(self.colorCode != .sozip_bg_3)
                                )
                                
                                Spacer().frame(height : 5)
                                
                                Button(action : {
                                    self.colorCode = .sozip_bg_4
                                }){
                                    Circle()
                                        .foregroundColor(.sozip_bg_4)
                                        .shadow(radius : 5)
                                        .frame(width : 40, height : 40)
                                }.overlay(
                                    Image(systemName : "checkmark")
                                        .foregroundColor(.white)
                                        .isHidden(self.colorCode != .sozip_bg_4)
                                )
                                
                                Spacer().frame(height : 5)
                                
                                Button(action : {
                                    self.colorCode = .sozip_bg_5
                                }){
                                    Circle()
                                        .foregroundColor(.sozip_bg_5)
                                        .shadow(radius : 5)
                                        .frame(width : 40, height : 40)
                                }.overlay(
                                    Image(systemName : "checkmark")
                                        .foregroundColor(.white)
                                        .isHidden(self.colorCode != .sozip_bg_5)
                                )
                            }
                        }
                        
                        Spacer().frame(height : 40)
                        
                        Button(action: {
                            if self.roomName.isEmpty || receiver.location.isEmpty || self.selectedDate == nil || userManagement.accounts.isEmpty{
                                alertModel = .emptyField
                                showAlert = true
                            }
                            
                            else{
                                isProcessing = true
                                
                                let accountModel = userManagement.accounts[page.index]
                                
                                let name = accountModel.name
                                let bank = accountModel.bank
                                let account = accountModel.accountNumber
                                
                                helper.addSOZIP(name: self.roomName + " 시키실 분!",
                                                receiver: self.receiver,
                                                dateTime: self.selectedDate,
                                                color : self.colorCode,
                                                account: "\(bank) \(account) \(name)",
                                                url : self.url,
                                                category : self.tags[selectedTag],
                                                firstCome : firstCome){result in

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
                            .frame(width : 300)
                            .background(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).shadow(radius: 5))
                            .disabled(self.roomName.isEmpty || receiver.location.isEmpty || self.selectedDate == nil || userManagement.accounts.isEmpty)
                            
                        }
                    }
                }
            }.navigationBarTitle(Text("소집 만들기"))
            .navigationBarItems(trailing: Button("닫기"){self.isShowing = false})
            .padding(20)
            .background(Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
            
            .accentColor(.accent)
            
            .alert(isPresented : $showAlert){
                switch(alertModel){
                case .success:
                    return Alert(title : Text("업로드 완료"),
                                 message : Text("소집이 추가되었어요!"),
                                 dismissButton : .default(Text("확인")){
                                    self.isShowing = false
                                 })
                    
                case .error :
                    return Alert(title : Text("오류"),
                                 message : Text("소집을 추가하는 중 문제가 발생했습니다.\n네트워크 상태를 확인하거나, 나중에 다시 시도해주세요."),
                                 primaryButton: .default(Text("피드백 허브")){
                                    
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
            
            .sheet(isPresented : $showAddAccount){
                addBankAccount()
            }
            
            .sheet(isPresented : $showTutorial){
                URLTutorialView()
            }
            
            .onAppear(perform : {
                userManagement.getAccountInfo()
            })
            
        }
    }
}

struct addSozipView_Previews: PreviewProvider {
    static var previews: some View {
        addSozipView(isShowing: .constant(true), receiver: SOZIPLocationReceiver(), userManagement: UserManagement())
    }
}
