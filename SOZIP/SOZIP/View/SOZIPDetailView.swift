//
//  SOZIPDetailView.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/02.
//

import SwiftUI
import Firebase

struct SOZIPDetailView: View {
    @State private var noMeetPreferred = false
    @State private var MeetPreferred = false
    @State private var isPositionEditing = false
    @State private var alertModel : participateSOZIPResultModel? = nil
    @State private var showAlert = false
    @State private var isProcessing = false
    @State private var isCachePay = false
    @State private var isBankPay = false
    @State private var isPrivatePay = false
    @State private var accept = false
    @State var position = ""
    let sozip : SOZIPDataModel
    let helper : SOZIPHelper
    
    var body: some View {
        ZStack{
            Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            VStack {
                SOZIPListModel(data : sozip)
                
                ScrollView{
                    VStack{
                        Spacer().frame(height : 20)
                        
                        HStack{
                            Text("소집 장소")
                                .fontWeight(.semibold)
                            
                            Spacer()
                        }
                        
                        Spacer().frame(height : 20)
                        
                        showMapView(data: sozip)
                            .frame(width : UIScreen.main.bounds.width / 1.2, height : UIScreen.main.bounds.height / 4)
                            .shadow(radius: 5)
                        
                        
                        Spacer().frame(height : 20)
                        
                        if !sozip.participants.keys.contains(Auth.auth().currentUser?.uid as! String) || sozip.Manager != Auth.auth().currentUser?.uid as! String{
                            Group {
                                HStack{
                                    Text("거래 방식 선택하기")
                                        .fontWeight(.semibold)
                                    
                                    Spacer()
                                }
                                
                                Spacer().frame(height : 20)
                                
                                Group{
                                    Button(action: {
                                        self.noMeetPreferred = true
                                        self.MeetPreferred = false
                                        self.isCachePay = false
                                    }){
                                        HStack{
                                            Image("ic_noMeet")
                                                .resizable()
                                                .frame(width : 40, height : 40)
                                                .foregroundColor(self.noMeetPreferred ? .white : .txt_color)
                                            
                                            Text("특정 장소에 놓고 가주세요")
                                                .foregroundColor(self.noMeetPreferred ? .white : .txt_color)
                                            
                                            Spacer()
                                            
                                            CheckBox_w(checked: $noMeetPreferred)
                                            
                                        }.padding(20)
                                        .background(
                                            RoundedRectangle(cornerRadius: 15)
                                                .padding(5)
                                                .foregroundColor(self.noMeetPreferred ? .accent : .btn_color)
                                                .shadow(radius: 5)
                                        )
                                        
                                    }
                                }
                                
                                Spacer().frame(height : 20)
                                
                                Group{
                                    Button(action: {
                                        self.noMeetPreferred = false
                                        self.MeetPreferred = true
                                    }){
                                        HStack{
                                            Image("ic_meet")
                                                .resizable()
                                                .frame(width : 40, height : 40)
                                                .foregroundColor(self.MeetPreferred ? .white : .txt_color)
                                            
                                            Text("소집 장소에서 만나요!")
                                                .foregroundColor(self.MeetPreferred ? .white : .txt_color)
                                            
                                            Spacer()
                                            
                                            CheckBox_w(checked: $MeetPreferred)
                                            
                                        }.padding(20)
                                        .background(
                                            RoundedRectangle(cornerRadius: 15)
                                                .padding(5)
                                                .foregroundColor(self.MeetPreferred ? .accent : .btn_color)
                                                .shadow(radius: 5)
                                        )
                                        
                                    }
                                }
                            }
                            
                            
                            
                            Spacer().frame(height : 20)
                            
                            if noMeetPreferred{
                                HStack {
                                    Image(systemName: "location.fill.viewfinder")
                                        .resizable()
                                        .frame(width : 20, height : 20)
                                    
                                    TextField("장소를 알려주세요 (ex. 현관 앞 책상 위)", text:$position, onEditingChanged: {(editing) in
                                        if editing{
                                            isPositionEditing = true
                                        }
                                        
                                        else{
                                            isPositionEditing = false
                                        }
                                    })
                                }
                                .foregroundColor(isPositionEditing ? Color.accent : Color.txt_color)
                                .padding(20)
                                .padding([.horizontal], 30)
                                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.btn_color).shadow(radius: 5)
                                                .padding([.horizontal],20))
                                
                                Text("소집 장소에서 너무 멀면 거부될 수 있어요.")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            if MeetPreferred || noMeetPreferred{
                                Spacer().frame(height : 20)
                                
                                HStack{
                                    Text("결제 방식 선택")
                                        .fontWeight(.semibold)
                                    
                                    Spacer()
                                }
                                
                                Spacer().frame(height : 5)
                                
                                Group {
                                    HStack {
                                        Text("소집 참여 후에도 변경할 수 있어요!")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        
                                        Spacer()
                                    }
                                    
                                    if MeetPreferred{
                                        Spacer().frame(height : 20)
                                        
                                        Button(action: {
                                            self.isCachePay = true
                                            self.isBankPay = false
                                            self.isPrivatePay = false
                                        }){
                                            VStack {
                                                HStack{
                                                    Image(systemName : "wonsign.circle.fill")
                                                        .resizable()
                                                        .frame(width : 40, height : 40)
                                                        .foregroundColor(self.isCachePay ? .white : .txt_color)
                                                    
                                                    Text("만나서 현금 지급")
                                                        .foregroundColor(self.isCachePay ? .white : .txt_color)
                                                    
                                                    Spacer()
                                                    
                                                    CheckBox_w(checked: $isCachePay)
                                                    
                                                }
                                                
                                                HStack {
                                                    Text("소집 장소에서 방장에게 현금을 지급해주세요!")
                                                        .font(.caption)
                                                        .foregroundColor(self.isCachePay ? .white : .txt_color)
                                                    
                                                    Spacer()
                                                }
                                            }.padding(20)
                                            .background(
                                                RoundedRectangle(cornerRadius: 15)
                                                    .padding(5)
                                                    .foregroundColor(self.isCachePay ? .accent : .btn_color)
                                                    .shadow(radius: 5)
                                            )
                                            
                                        }
                                    }
                                    
                                    Spacer().frame(height : 20)
                                    
                                    Button(action: {
                                        self.isCachePay = false
                                        self.isBankPay = true
                                        self.isPrivatePay = false
                                    }){
                                        VStack {
                                            HStack{
                                                Image("ic_bankTransfer")
                                                    .resizable()
                                                    .frame(width : 40, height : 40)
                                                    .foregroundColor(self.isBankPay ? .white : .txt_color)
                                                
                                                Text("방장 계좌로 계좌 이체")
                                                    .foregroundColor(self.isBankPay ? .white : .txt_color)
                                                
                                                Spacer()
                                                
                                                CheckBox_w(checked: $isBankPay)
                                                
                                            }
                                            
                                            HStack {
                                                Text("소집에 참여하면 방장 계좌가 표시됩니다.")
                                                    .font(.caption)
                                                    .foregroundColor(self.isBankPay ? .white : .txt_color)
                                                
                                                Spacer()
                                            }
                                        }.padding(20)
                                        .background(
                                            RoundedRectangle(cornerRadius: 15)
                                                .padding(5)
                                                .foregroundColor(self.isBankPay ? .accent : .btn_color)
                                                .shadow(radius: 5)
                                        )
                                        
                                    }
                                    
                                    Spacer().frame(height : 20)
                                    
                                    Button(action: {
                                        self.isCachePay = false
                                        self.isBankPay = false
                                        self.isPrivatePay = true
                                    }){
                                        VStack {
                                            HStack{
                                                Image(systemName : "shield.lefthalf.fill")
                                                    .resizable()
                                                    .frame(width : 35, height : 40)
                                                    .foregroundColor(self.isPrivatePay ? .white : .txt_color)
                                                
                                                Spacer().frame(width : 5)
                                                
                                                Text("안전 결제")
                                                    .foregroundColor(self.isPrivatePay ? .white : .txt_color)
                                                
                                                Spacer()
                                                
                                                CheckBox_w(checked: $isPrivatePay)
                                                
                                            }
                                            
                                            HStack {
                                                Text("이제이 계좌로 송금한 후 소집이 완료되면 방장에게 돈이 지급됩니다.")
                                                    .font(.caption)
                                                    .foregroundColor(self.isPrivatePay ? .white : .txt_color)
                                                
                                                Spacer()
                                            }
                                        }.padding(20)
                                        .background(
                                            RoundedRectangle(cornerRadius: 15)
                                                .padding(5)
                                                .foregroundColor(self.isPrivatePay ? .accent : .btn_color)
                                                .shadow(radius: 5)
                                        )
                                        
                                    }
                                }
                                
                                
                                
                            }
                            
                            Spacer().frame(height : 20)
                            
                            if !sozip.participants.keys.contains(Auth.auth().currentUser?.uid as! String){
                                Button(action : {
                                    if !self.MeetPreferred && !self.noMeetPreferred{
                                        alertModel = .blankField
                                        showAlert = true
                                    }
                                    
                                    else if !self.isPrivatePay && !self.isBankPay && !self.isCachePay{
                                        alertModel = .noPayMethod
                                        showAlert = true
                                    }
                                    
                                    else{
                                        isProcessing = true
                                        var method = ""
                                        var payMethod = ""
                                        
                                        if self.MeetPreferred{
                                            method = "Meet"
                                        }
                                        
                                        else{
                                            method = position
                                        }
                                        
                                        if self.isBankPay{
                                            payMethod = "bank"
                                        }
                                        
                                        else if self.isCachePay{
                                            payMethod = "cache"
                                        }
                                        
                                        else if self.isPrivatePay{
                                            payMethod = "private"
                                        }
                                        
                                        helper.participate_SOZIP(method: method, docId: sozip.docId, position: position, payMethod : payMethod, transactionMethod: method){(result) in
                                            guard let result = result else{return}
                                            
                                            if result == "success"{
                                                isProcessing = false
                                                alertModel = .success
                                                showAlert = true
                                            }
                                            
                                            else if result == "already_participated"{
                                                isProcessing = false
                                                alertModel = .already_participated
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
                                        Text("소집 참여하기")
                                            .foregroundColor(.white)
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.white)
                                    }.padding(20)
                                    .padding([.horizontal], 60)
                                    .background(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).shadow(radius: 5).foregroundColor(self.MeetPreferred == false && self.noMeetPreferred == false ? .gray : .accent))
                                }
                            }
                            
                            
                        }
                        
                        if sozip.participants.keys.contains(Auth.auth().currentUser?.uid as! String) && sozip.Manager != Auth.auth().currentUser?.uid as! String{
                            Text("이미 참여 중인 소집이예요.")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Spacer().frame(height : 20)
                            
                            Button(action : {
                                isProcessing = true
                                var method = ""
                                var payMethod = ""
                                
                                if self.MeetPreferred{
                                    method = "Meet"
                                }
                                
                                else{
                                    method = position
                                }
                                
                                if self.isBankPay{
                                    payMethod = "bank"
                                }
                                
                                else if self.isCachePay{
                                    payMethod = "cache"
                                }
                                
                                else if self.isPrivatePay{
                                    payMethod = "private"
                                }
                                
                                helper.changeInformation(docId : sozip.docId, payMethod : payMethod, transactionMethod : method){result in
                                    guard let result = result else{return}
                                    
                                    if result == "success" {
                                        isProcessing = false
                                        alertModel = .done_update
                                        showAlert = true
                                        
                                    }
                                    
                                    else{
                                        isProcessing = false
                                        alertModel = .error_update
                                        showAlert = true
                                    }
                                    
                                    
                                    
                                    
                                }
                            }){
                                HStack{
                                    Text("정보 업데이트하기")
                                        .foregroundColor(.white)
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.white)
                                }.padding(20)
                                .padding([.horizontal], 60)
                                .background(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).shadow(radius: 5).foregroundColor(.accent))
                            }
                            
                            Spacer().frame(height : 20)
                            
                            Button(action : {
                                self.alertModel = .exit
                                showAlert = true
                            }){
                                HStack{
                                    Image(systemName: "xmark")
                                        .foregroundColor(.red)
                                    
                                    Text("소집 취소하기")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        
                        else if sozip.Manager == Auth.auth().currentUser?.uid as! String{
                            
                            Spacer().frame(height : 20)
                            
                            Group {
                                if sozip.status == ""{
                                    SOZIPManagerView(model : sozip)
                                    
                                    Spacer().frame(height : 20)
                                    
                                    VStack {
                                        Text("소집을 취소하고 싶으신가요?")
                                            .fontWeight(.bold)
                                        
                                        Spacer().frame(height : 10)
                                        
                                        Text("소집 멤버들에게 돈을 받으셨다면, 돈을 돌려준 후 소집을 취소해주세요!\n정산하지 않을 경우 고객님의 계정이 정지되며, 법적인 처벌을 받을 수 있습니다.")
                                            .font(.caption)
                                            .multilineTextAlignment(.center)
                                        
                                        Spacer().frame(height : 20)
                                        
                                        HStack{
                                            CheckBox(checked: $accept)
                                            
                                            Text("위 내용을 읽고 이해했으며, 비용 정산을 완료했습니다.")
                                                .font(.caption)
                                                .onTapGesture(perform: {
                                                    if accept{
                                                        accept = false
                                                    }
                                                    
                                                    else{
                                                        self.accept = true
                                                    }
                                                })
                                            
                                            Spacer()
                                            
                                        }
                                    }.padding(20).background(RoundedRectangle(cornerRadius: 15.0).shadow(radius: 5).foregroundColor(.btn_color))
                                    
                                    Spacer().frame(height : 20)
                                    
                                    Button(action : {
                                        if !accept{
                                            alertModel = .requireAccept
                                            showAlert = true
                                        }
                                        
                                        else{
                                            alertModel = .close
                                            showAlert = true
                                        }
                                        
                                    }){
                                        HStack{
                                            Image(systemName: "xmark")
                                                .foregroundColor(.white)
                                            
                                            Text("소집 전체 취소하기")
                                                .foregroundColor(.white)
                                        }.padding(20)
                                        .padding([.horizontal], 60)
                                        .background(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).shadow(radius: 5).foregroundColor(.red))
                                    }
                                    
                                    Spacer().frame(height : 20)

                                    Button(action : {
                                        alertModel = .pause
                                        showAlert = true
                                    }){
                                        HStack{
                                            Image(systemName : "pause.circle.fill")
                                                .foregroundColor(.accent)
                                            
                                            Text("소집 일시 정지하기")
                                                .font(.caption)
                                                .foregroundColor(.accent)
                                        }
                                    }
                                }
                                
                                Spacer().frame(height : 20)
                                
                                
                                if sozip.status == "paused"{
                                    Text("일시 정지된 소집이예요.")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        
                                    Spacer().frame(height : 10)

                                    Button(action : {
                                        alertModel = .resume
                                        showAlert = true
                                    }){
                                        HStack{
                                            Image(systemName : "arrow.clockwise")
                                                .foregroundColor(.blue)
                                            
                                            Text("소집 다시 시작하기")
                                                .font(.caption)
                                                .foregroundColor(.blue)
                                        }
                                    }
                                }
                                
                                if sozip.status == "closed"{
                                    Text("종료된 소집이예요.")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            
                        }
                    }
                }
            }.padding(20)
            
        }.navigationBarTitle(Text(sozip.SOZIPName), displayMode: .inline)
        
        .navigationBarItems(trailing : Button(action : {}){
            Image(systemName : "exclamationmark.bubble.fill")
                .foregroundColor(.red)
        })
        
        .overlay(
            ProcessView()
                .isHidden(!isProcessing)
        )
        
        .onAppear(perform : {
            if sozip.participants.keys.contains(Auth.auth().currentUser?.uid as! String) && sozip.Manager != Auth.auth().currentUser?.uid as! String{
                
                if index != nil{
                    switch sozip.payMethod[Auth.auth().currentUser?.uid as! String]{
                    case "bank":
                        self.isBankPay = true
                        
                    case "cache" :
                        self.isCachePay = true
                        
                    case "private" :
                        self.isPrivatePay = true
                        
                    default :
                        break
                    }
                    
                    
                    if sozip.transactionMethod[Auth.auth().currentUser?.uid as! String] == "Meet"{
                        self.MeetPreferred = true
                    }
                    
                    else{
                        self.noMeetPreferred = true
                        self.position = sozip.transactionMethod[Auth.auth().currentUser?.uid as! String] ?? ""
                    }
                }
                
                
            }
        })
        
        .alert(isPresented : $showAlert){
            switch alertModel{
            case .success:
                return Alert(title : Text("참여 완료"),
                             message : Text("소집에 참여했어요!"),
                             dismissButton : .default(Text("확인")))
                
            case .noPayMethod:
                return Alert(title : Text("결제 방식 선택"),
                             message : Text("결제 방식을 선택해주세요."),
                             dismissButton : .default(Text("확인")))
                
            case .none:
                break
                
            case .error:
                return Alert(title : Text("오류"),
                             message : Text("소집에 참여하는 중 문제가 발생했습니다.\n네트워크 상태를 확인하거나, 나중에 다시 시도하십시오."),
                             dismissButton : .default(Text("확인")))
                
            case .already_participated:
                return Alert(title : Text("이미 참여 중인 소집"),
                             message : Text("이미 참여 중인 소집이예요."),
                             dismissButton : .default(Text("확인")))
                
            case .blankField:
                return Alert(title : Text("거래 방식 선택"),
                             message : Text("거래 방식을 선택해주세요."),
                             dismissButton : .default(Text("확인")))
                
            case .exit:
                return Alert(title: Text("소집 나가기"), message: Text("소집에서 나갈까요?\n소집에서 나가면 채팅방에서 자동으로 내보내집니다.\n방장에게 돈을 송금하였으나, 받지 못한 경우 신고 기능을 이용해주세요."), primaryButton: .default(Text("예")){
                    isProcessing = true
                    
                    helper.exit_SOZIP(docId: sozip.docId){(result) in
                        guard let result = result else{return}
                        
                        if result == "success"{
                            isProcessing = false
                            alertModel = .done_exit
                            showAlert = true
                        }
                        
                        else if result == "already_exit"{
                            isProcessing = false
                            alertModel = .already_exit
                            showAlert = true
                        }
                        
                        else{
                            isProcessing = false
                            alertModel = .error_exit
                            showAlert = true
                        }
                    }
                }, secondaryButton: .default(Text("아니오")))
                
            case .done_exit:
                return Alert(title: Text("나가기 완료"),
                             message: Text("소집에서 나왔어요.\n돈을 돌려받지 못한 경우 신고 기능을 이용해주세요."),
                             dismissButton: .default(Text("확인")))
                
            case .error_exit:
                return Alert(title: Text("나가기 오류"),
                             message: Text("소집에서 나가는 중 오류가 발생했습니다.\n네트워크 상태를 확인하거나, 나중에 다시 시도하십시오."),
                             dismissButton: .default(Text("확인")))
                
            case .already_exit:
                return Alert(title: Text("이미 나온 소집"),
                             message: Text("이미 소집에서 나왔어요."),
                             dismissButton: .default(Text("확인")))
                
            case .done_close:
                return Alert(title: Text("취소 완료"),
                             message: Text("소집이 취소되었어요."),
                             dismissButton: .default(Text("확인")))
                
            case .error_close:
                return Alert(title: Text("취소 오류"),
                             message: Text("소집을 취소하는 중 오류가 발생했습니다.\n네트워크 상태를 확인하거나, 나중에 다시 시도하십시오."),
                             dismissButton: .default(Text("확인")))
                
            case .already_close:
                return Alert(title: Text("이미 취소된 소집"),
                             message: Text("이미 소집이 취소되었어요."),
                             dismissButton: .default(Text("확인")))
                
            case .close:
                return Alert(title: Text("소집 취소하기"), message: Text("소집을 취소할까요?\n소집을 취소하면 채팅방이 자동으로 사라지고, 소집 목록에 표시되지 않습니다."), primaryButton: .default(Text("예")){
                    isProcessing = true
                    
                    helper.close_SOZIP(docId: sozip.docId){(result) in
                        guard let result = result else{return}
                        
                        if result == "success"{
                            isProcessing = false
                            alertModel = .done_close
                            showAlert = true
                        }
                        
                        else if result == "already_closed"{
                            isProcessing = false
                            alertModel = .already_close
                            showAlert = true
                        }
                        
                        else{
                            isProcessing = false
                            alertModel = .error_close
                            showAlert = true
                        }
                    }
                }, secondaryButton: .default(Text("아니오")))
                
            case .done_update:
                return Alert(title: Text("업데이트 완료"),
                             message: Text("정보를 업데이트했어요."),
                             dismissButton: .default(Text("확인")))
                
            case .error_update:
                return Alert(title: Text("업데이트 실패"),
                             message: Text("정보 업데이트 중 문제가 발생했습니다.\n네트워크 상태를 확인하거나, 나중에 다시 시도하십시오."),
                             dismissButton: .default(Text("확인")))
                
            case .requireAccept:
                return Alert(title: Text("동의 필요"),
                             message: Text("소집 취소와 관련된 내용을 읽고 동의해주세요."),
                             dismissButton: .default(Text("확인")))
                
            case .pause:
                return Alert(title: Text("소집 일시정지"), message: Text("소집을 일시정지할까요?\n일시정지 상태에서는 소집 목록에 표시되지 않습니다."), primaryButton: .default(Text("예")){
                    isProcessing = true
                    
                    helper.pauseSOZIP(docId: sozip.docId){(result) in
                        guard let result = result else{return}
                        
                        if result == "success"{
                            isProcessing = false
                            alertModel = .done_pause
                            showAlert = true
                        }
                        
                        else{
                            isProcessing = false
                            alertModel = .error_pause
                            showAlert = true
                        }
                    }
                }, secondaryButton: .default(Text("아니오")))
                
            case .done_pause:
                return Alert(title: Text("일시정지 완료"),
                             message: Text("소집이 일시정지 되었어요."),
                             dismissButton: .default(Text("확인")))
                
            case .error_pause:
                return Alert(title: Text("일시정지 오류"),
                             message: Text("소집을 일시정지 하는 중 문제가 발생했습니다.\n네트워크 상태를 확인하거나, 나중에 다시 시도하십시오."),
                             dismissButton: .default(Text("확인")))
                
            case .resume:
                return Alert(title: Text("소집 다시 시작"), message: Text("소집을 다시 시작할까요?\n다시 시작하면, 소집 목록에 표시됩니다."), primaryButton: .default(Text("예")){
                    isProcessing = true
                    
                    helper.resumeSOZIP(docId: sozip.docId){(result) in
                        guard let result = result else{return}
                        
                        if result == "success"{
                            isProcessing = false
                            alertModel = .done_resume
                            showAlert = true
                        }
                        
                        else{
                            isProcessing = false
                            alertModel = .error_resume
                            showAlert = true
                        }
                    }
                }, secondaryButton: .default(Text("아니오")))
                
            case .done_resume:
                return Alert(title: Text("다시 시작 완료"),
                             message: Text("소집이 다시 시작되었어요."),
                             dismissButton: .default(Text("확인")))
                
            case .error_resume:
                return Alert(title: Text("다시 시작 오류"),
                             message: Text("소집을 다시 시작 하는 중 문제가 발생했습니다.\n네트워크 상태를 확인하거나, 나중에 다시 시도하십시오."),
                             dismissButton: .default(Text("확인")))
            }
            
            return Alert(title : Text(""),
                         message : Text(""),
                         dismissButton : .default(Text("확인")))
        }
        
    }
}
