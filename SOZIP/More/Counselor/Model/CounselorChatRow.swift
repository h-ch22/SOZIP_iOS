//
//  CounselorChatRow.swift
//  SOZIP
//
//  Created by 하창진 on 2021/09/10.
//

import SwiftUI
import Firebase

struct CounselorChatRow: View {
    let data : CounselorChatDataModel
    let type : String
    @State private var isMyMSG = false
    @State private var url = ""
    @State private var msg_split : [Any] = []
    
    func convertTime() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy/MM/dd kk:mm:ss.SSSS"
        var date : Date? = nil
        var dateFormatter_modify = DateFormatter()
        
        if data.dateTime != "" && data.dateTime != nil{
            date = dateFormatter.date(from: data.dateTime!)
            
            dateFormatter_modify.dateFormat = "HH:mm"
        }
        
        return dateFormatter_modify.string(from: date ?? Date())
    }
    
    var body: some View {
        VStack{
            HStack{
                if !isMyMSG{
                    if type == "Manager"{
                        Image("ic_counselor")
                            .resizable()
                            .frame(width : 25, height : 25)
                            .padding(5)
                        
                        Text("고객님")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Spacer()
                    }
                    
                    else{
                        Image("ic_counselor")
                            .resizable()
                            .frame(width : 25, height : 25)
                            .padding(5)
                        
                        Text("상담원")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Spacer()
                    }
                    
                }
                
                else{
                    Spacer()
                }
            }
            
            HStack{
                if isMyMSG{
                    Spacer()
                    
                    VStack{
                        Spacer()
                        
                        Text(convertTime())
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
                
                if data.msg_type == "text"{
                    Text(data.msg ?? "")
                        .padding()
                        .fixedSize(horizontal : false, vertical : true)
                        .background(isMyMSG ? Color.accent : .gray)
                        .clipShape(BubbleShape(myMessage: isMyMSG))
                        .foregroundColor(.white)
                        .onAppear(perform : {
                            if data.msg != nil{
                                let detector = try! NSDataDetector(types : NSTextCheckingResult.CheckingType.link.rawValue)
                                
                                let matches = detector.matches(in: data.msg!, options: [], range: NSRange(location: 0, length: data.msg!.utf16.count))
                                
                                for match in matches {
                                    guard let range = Range(match.range, in: data.msg!) else { continue }
                                    let url = data.msg![range]
                                    self.url = String(url)
                                }
                            }
                            
                        })
                    
                    if !isMyMSG{
                        Spacer().frame(width : 10)
                        
                        VStack {
                            
                            Spacer()
                            
                            Text(convertTime())
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                    }
                    
                }
                
                else if data.msg_type == "start"{
                    VStack{
                        Image("ic_counselor")
                            .resizable()
                            .frame(width : 50, height : 50)
                            .foregroundColor(.white)
                        
                        Text("안녕하세요, 고객님")
                        
                        Spacer().frame(height : 5)

                        Text("고객님과의 상담을 위해 상담원이 현재 준비 중입니다.\n상담 내용을 보내놓으시면 더욱 원활한 상담이 가능합니다.")
                            .foregroundColor(.white)
                            .font(.caption)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal : false, vertical : true)
                        
                    }.padding()
                    .background(isMyMSG ? Color.accent : .gray)
                    .clipShape(BubbleShape(myMessage: isMyMSG))
                    .foregroundColor(.white)
                    
                    if !isMyMSG{
                        Spacer().frame(width : 10)
                        
                        VStack {
                            Spacer()
                            
                            Text(convertTime())
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                    }
                }
            }
        }.onAppear(perform : {
            if data.sender == Auth.auth().currentUser?.uid ?? ""{
                isMyMSG = true
            }
            
            else{
                isMyMSG = false
            }
        })
    }
}
