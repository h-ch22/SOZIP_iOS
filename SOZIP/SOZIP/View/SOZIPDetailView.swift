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
                            .frame(width : UIScreen.main.bounds.width / 1.2, height : UIScreen.main.bounds.height / 3)
                            .shadow(radius: 5)
                        
                        Spacer().frame(height : 20)
                        
                        if sozip.url != nil && sozip.url != "" && sozip.url != "about:blank"{
                            Button(action : {
                                if let url = URL(string : sozip.url!){
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
                                }.padding(20).background(RoundedRectangle(cornerRadius: 15.0).shadow(radius: 5).foregroundColor(.btn_color))
                                
                                
                            }
                            
                        }
                        
                        Spacer().frame(height : 20)
                        
                        if !sozip.participants.keys.contains(Auth.auth().currentUser?.uid as! String) || sozip.Manager != Auth.auth().currentUser?.uid as! String && sozip.firstCome >= sozip.currentPeople{
                            
                            if !sozip.participants.keys.contains(Auth.auth().currentUser?.uid as! String){
                                Button(action : {
                                    
                                    isProcessing = true
                                    
                                    helper.participate_SOZIP(docId: sozip.docId, position: position){(result) in
                                        guard let result = result else{return}
                                        
                                        if result == "success"{
                                            isProcessing = false
                                            alertModel = .success
                                            showAlert = true
                                        }
                                        
                                        else if result == "limitPeople"{
                                            isProcessing = false
                                            alertModel = .limitPeople
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
                                }){
                                    HStack{
                                        Text("소집 참여하기")
                                            .foregroundColor(.white)
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.white)
                                    }.padding(20)
                                    .padding([.horizontal], 60)
                                    .background(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).shadow(radius: 5).foregroundColor(.accent))
                                }
                            }
                            
                            
                        }
                        
                        if sozip.participants.keys.contains(Auth.auth().currentUser?.uid as! String) && sozip.Manager != Auth.auth().currentUser?.uid as! String{
                            SOZIPManagerView(model : sozip)
                            
                            Spacer().frame(height : 20)
                            
                            Text("이미 참여 중인 소집이예요.")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Spacer().frame(height : 20)
                            
                            Button(action : {
                                self.alertModel = .exit
                                showAlert = true
                            }){
                                HStack{
                                    Image(systemName: "xmark")
                                        .foregroundColor(.white)
                                    
                                    Text("소집 취소하기")
                                        .foregroundColor(.white)
                                }.padding(20)
                                .padding([.horizontal], 60)
                                .background(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).shadow(radius: 5).foregroundColor(.red))
                            }
                        }
                        
                        else if sozip.Manager == Auth.auth().currentUser?.uid as! String{
                            
                            Spacer().frame(height : 20)
                            
                            Group {
                                if sozip.status == "" || sozip.status == "end"{
                                    SOZIPManagerView(model : sozip)
                                    
                                    Spacer().frame(height : 20)
                                    
                                    if sozip.status == ""{
                                        
                                        VStack {
                                            Text("소집을 취소하고 싶으신가요?")
                                                .fontWeight(.bold)
                                            
                                            Spacer().frame(height : 10)
                                            
                                            Text("소집 멤버들에게 돈을 받으셨다면, 돈을 돌려준 후 소집을 취소해주세요! 정산하지 않을 경우 고객님의 계정이 정지되며,법적인 처벌을 받을 수 있습니다.")
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
                                
                                if sozip.status == "end"{
                                    Text("완료된 소집이예요.")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                                if sozip.currentPeople >= sozip.firstCome{
                                    Text("허용 인원 수를 초과했어요.")
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
        
        .alert(isPresented : $showAlert){
            switch alertModel{
            case .success:
                return Alert(title : Text("참여 완료"),
                             message : Text("소집에 참여했어요!\n채팅으로 이동해서 소집을 진행해주세요!"),
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
                return Alert(title: Text("소집 취소하기"), message: Text("소집을 취소할까요?\n소집을 취소하면 채팅방이 5시간 후 사라지고, 소집 목록에 표시되지 않습니다."), primaryButton: .default(Text("예")){
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
                
            case .limitPeople:
                return Alert(title : Text("허용 인원 초과"),
                             message : Text("소집 허용 인원을 초과했습니다."),
                             dismissButton: .default(Text("확인")))
            }
            
            return Alert(title : Text(""),
                         message : Text(""),
                         dismissButton : .default(Text("확인")))
        }
        
    }
}
