//
//  ChatContentsRow.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/25.
//

import SwiftUI
import Firebase
import Alamofire
import SwiftyJSON
import SDWebImageSwiftUI

struct ChatContentsRow: View {
    var data : ChatDataModel
    var SOZIPData : ChatListDataModel
    
    let account : String
    
    @State private var msg = ""
    @State private var isMyMSG = false
    @State private var accountNumber = ""
    @State private var bank = ""
    @State private var name = ""
    @State private var consonant = ""
    @State private var url = ""
    @State private var msg_split : [Any] = []
    @State private var textStyle = UIFont.TextStyle.body
    @State var redrawPreview = false

    func convertTime() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy/MM/dd kk:mm:ss.SSSS"
        
        let date = dateFormatter.date(from: data.time)
        
        let dateFormatter_modify = DateFormatter()
        dateFormatter_modify.dateFormat = "HH:mm"
                
        return dateFormatter_modify.string(from: date ?? Date())
    }
    
    func splitText() -> Bool{
        consonant = ""
        var unicodeArr : [UnicodeScalar] = []
        
        for i in 0..<name.count{
            let index = name.index(name.startIndex, offsetBy: i)

            if String(name[index]) != " "{
                let char : String = String(name[index])
                
                let val = UnicodeScalar(char)?.value
                guard let value = val else{
                    return false
                }
                
                if value >= 0xac00 && value <= 0xd7af{
                    let x = (value - 0xac00) / 28 / 21
                    
                    let result = UnicodeScalar(0x1100 + x)
                    
                    unicodeArr.append(result!)
                }
                
                else{
                    unicodeArr.append(UnicodeScalar(val!)!)
                }
            }
        }
        
        for i in unicodeArr.indices{
            consonant.append("\(unicodeArr[i])")
        }
        
        return true
    }
    
    var body: some View {
        VStack{
            HStack{
                if !isMyMSG{
                    Text(data.profile)
                        .modifier(FittingFontSizeModifier())
                        .frame(width : 25, height : 25)
                        .padding(5)
                        .background(Circle().foregroundColor(data.profile_BG))
                    
                    Text(data.nickName)
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer()
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
                
                if data.type == "text"{
                        Text(AES256Util.decrypt(encoded : data.msg))
                            .padding()
                            .fixedSize(horizontal : false, vertical : true)
                            .background(isMyMSG ? SOZIPData.color : .gray)
                            .clipShape(BubbleShape(myMessage: isMyMSG))
                            .foregroundColor(.white)
                            .onAppear(perform : {
                                let detector = try! NSDataDetector(types : NSTextCheckingResult.CheckingType.link.rawValue)
                                
                                let matches = detector.matches(in: AES256Util.decrypt(encoded : data.msg), options: [], range: NSRange(location: 0, length: AES256Util.decrypt(encoded : data.msg).utf16.count))

                                for match in matches {
                                    guard let range = Range(match.range, in: AES256Util.decrypt(encoded : data.msg)) else { continue }
                                    let url = AES256Util.decrypt(encoded : data.msg)[range]
                                    self.msg = AES256Util.decrypt(encoded : data.msg)
                                    self.url = String(url)
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
                
                else if data.type == "participate"{
                    VStack{
                        Text("🎉")
                            .font(.title)
                        
                        Text(AES256Util.decrypt(encoded : data.msg))
                        
                        Spacer().frame(height : 5)

                        Text("메뉴를 결정한 후 정산을 완료해주세요!")
                            .foregroundColor(.white)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal : false, vertical : true)
                        
                    }.padding()
                    .background(isMyMSG ? SOZIPData.color : .gray)
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
                
                
                
                else if data.type == "image"{
                    if !data.url.isEmpty{
                        if data.imageIndex == 1{
                            VStack {
                                WebImage(url: URL(string : data.url[0]))
                                    .resizable()
                                    .frame(width: 150, height: 150)
                                    .scaledToFit()
                            }.padding()
                            .background(isMyMSG ? SOZIPData.color : .gray)
                            .clipShape(BubbleShape(myMessage: isMyMSG))
                        } else{
                            var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)

                            LazyVGrid(columns : columns){
                                ForEach(0..<data.imageIndex!, id : \.self){ item in
                                    WebImage(url: URL(string : data.url[item]))
                                        .resizable()
                                        .frame(width: 150, height: 150)
                                        .scaledToFit()
                                }

                            }.padding()
                                .background(isMyMSG ? SOZIPData.color : .gray)
                                .clipShape(BubbleShape(myMessage: isMyMSG))
                        }
                        
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
                
                else if data.type == "account"{
                    VStack{
                        Image(systemName : "wonsign.circle.fill")
                            .resizable()
                            .frame(width : 50, height : 50)
                            .foregroundColor(.white)
                        
                        Text(AES256Util.decrypt(encoded : data.msg))
                            .fontWeight(.semibold)
                            .font(.title2)
                            .foregroundColor(.white)
                        
                        Spacer().frame(height : 15)
                        
                        Text("\(bank) \(accountNumber)\n\(consonant)")
                            .foregroundColor(.white)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal : false, vertical : true)
                            
                            
                    }.padding()
                    .background(isMyMSG ? SOZIPData.color : .gray)
                    .clipShape(BubbleShape(myMessage: isMyMSG))
                    .foregroundColor(.white)
                    .onAppear(perform : {
                        if data.sender == SOZIPData.Manager{
                            let accountInf = account.components(separatedBy: " ")
                            
                            self.bank = AES256Util.decrypt(encoded: accountInf[0])
                            self.accountNumber = AES256Util.decrypt(encoded: accountInf[1])
                            self.name = AES256Util.decrypt(encoded: accountInf[2])
                            
                            _ = splitText()
                        }
                        
                        else{
                            let accountInf = data.account?.components(separatedBy: " ")
                            
                            self.bank = AES256Util.decrypt(encoded: accountInf?[0] ?? "정보 없음")
                            self.accountNumber = AES256Util.decrypt(encoded: accountInf?[1] ?? "정보 없음")
                            self.name = AES256Util.decrypt(encoded: accountInf?[2] ?? "")
                            
                            _ = splitText()
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
                
                else if data.type == "exit"{
                    VStack{
                        Text("🥺")
                            .font(.title)
                        
                        Text(AES256Util.decrypt(encoded : data.msg))
                    }.padding()
                    .background(isMyMSG ? SOZIPData.color : .gray)
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
                
                else if data.type == "end"{
                    VStack{
                        Text("😆")
                            .font(.title)
                        
                        Text(AES256Util.decrypt(encoded : data.msg))
                        
                        
                        Spacer().frame(height : 15)
                        
                        Text("메뉴 선정과 정산을 완료해주세요!")
                            .foregroundColor(.white)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal : false, vertical : true)
                        
                    }.padding()
                    .background(isMyMSG ? SOZIPData.color : .gray)
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
                
                else if data.type == "cancel"{
                    VStack{
                        Image(systemName : "exclamationmark.circle.fill")
                            .resizable()
                            .frame(width : 50, height : 50)
                            .foregroundColor(.white)
                        
                        Text(AES256Util.decrypt(encoded : data.msg))
                        
                        
                        Spacer().frame(height : 15)
                        
                        Text("다른 소집을 찾아보세요!")
                            .foregroundColor(.white)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal : false, vertical : true)
                        
                    }.padding()
                    .background(isMyMSG ? SOZIPData.color : .gray)
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
            
            if self.url != ""{
                Spacer().frame(height : 20)

                LinkRow(previewURL : url, redraw : self.$redrawPreview)
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
//
//struct ChatContentsRow_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatContentsRow(data: ChatDataModel(rootDocId: "", docId: "", msg: "hi", sender: "", unread: 0, time: "21/08/23 23:09:27.2500", type: "text", url: "", imageIndex: nil, profile: "🐥", profile_BG: .sozip_bg_3, nickName: "changjin"))
//    }
//}
