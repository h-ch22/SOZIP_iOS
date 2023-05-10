//
//  ChatListModel.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/25.
//

import SwiftUI
import Firebase

struct ChatListModel: View {
    let data : ChatListDataModel
    @State private var profiles : [String] = []
    @State private var profile_bg : [Color] = []
    
    func convertTime() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy/MM/dd kk:mm:ss.SSSS"
        
        let date = dateFormatter.date(from: data.last_msg_time)
        
        let dateFormatter_modify = DateFormatter()
        dateFormatter_modify.dateFormat = "MM.dd HH:mm"
                
        return dateFormatter_modify.string(from: date ?? Date())
    }
    
    func setProfiles(){
        let profile_values = Array(data.profiles.values)
        
        for i in 0..<profile_values.count{
            let profile = profile_values[i].components(separatedBy: ",")
            
            switch profile[0]{
            case "pig" :
                self.profiles.append("🐷")
                
            case "rabbit":
                self.profiles.append("🐰")

            case "tiger" :
                self.profiles.append("🐯")

            case "monkey" :
                self.profiles.append("🐵")

            case "chick" :
                self.profiles.append("🐥")

            default :
                self.profiles.append("🐥")
            }
        }
    }
    
    func setProfileBG(){
        let profile_values = Array(data.profiles.values)
        
        for i in 0..<profile_values.count{
            let profile = profile_values[i].components(separatedBy: ",")
            
            switch profile[1]{
            case "bg_1":
                self.profile_bg.append(.sozip_bg_1)
                
            case "bg_2":
                self.profile_bg.append(.sozip_bg_2)

            case "bg_3":
                self.profile_bg.append(.sozip_bg_3)

            case "bg_4":
                self.profile_bg.append(.sozip_bg_4)

            case "bg_5":
                self.profile_bg.append(.sozip_bg_5)

            default:
                self.profile_bg.append(.sozip_bg_1)

            }
        }
    }
    
    var body: some View {
        VStack{
            HStack{
                if !profiles.isEmpty && !profile_bg.isEmpty{
                    if data.currentPeople == 1{
                        Text(profiles[0])
                            .modifier(FittingFontSizeModifier())
                            .frame(width : 25, height : 25)
                            .padding(5)
                            .background(RoundedRectangle(cornerRadius: 12.5).foregroundColor(profile_bg[0]))
                    }
                    
                    if data.currentPeople == 2{
                        HStack{
                            ForEach(0...1, id : \.self){index in
                                Text(profiles[index])
                                    .modifier(FittingFontSizeModifier())
                                    .frame(width : 12.5, height : 12.5)
                                    .padding(5)
                                    .background(RoundedRectangle(cornerRadius: 5).foregroundColor(profile_bg[index]))
                            }
                        }
                    }
                    
                    if data.currentPeople == 3{
                        VStack{
                            HStack{
                                ForEach(0...1, id : \.self){index in
                                    Text(profiles[index])
                                        .modifier(FittingFontSizeModifier())
                                        .frame(width : 12.5, height : 12.5)
                                        .padding(5)
                                        .background(RoundedRectangle(cornerRadius: 5).foregroundColor(profile_bg[index]))
                                }
                            }
                            
                            Text(profiles[2])
                                .modifier(FittingFontSizeModifier())
                                .frame(width : 12.5, height : 12.5)
                                .padding(5)
                                .background(RoundedRectangle(cornerRadius: 5).foregroundColor(profile_bg[2]))
                            
                        }
                    }
                    
                    if data.currentPeople >= 4{
                        VStack{
                            HStack{
                                ForEach(0...1, id : \.self){index in
                                    Text(profiles[index])
                                        .modifier(FittingFontSizeModifier())
                                        .frame(width : 12.5, height : 12.5)
                                        .padding(5)
                                        .background(RoundedRectangle(cornerRadius: 5).foregroundColor(profile_bg[index]))
                                }
                            }
                            
                            HStack{
                                ForEach(2...3, id : \.self){index in
                                    Text(profiles[index])
                                        .modifier(FittingFontSizeModifier())
                                        .frame(width : 12.5, height : 12.5)
                                        .padding(5)
                                        .background(RoundedRectangle(cornerRadius: 5).foregroundColor(profile_bg[index]))
                                }
                            }
                            
                        }
                    }
                }
                
                Text(data.SOZIPName)
                    .fontWeight(.semibold)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.txt_color)
                
                Text(String(data.currentPeople))
                    .font(.caption)
                    .foregroundColor(.gray)
                
                if data.Manager == Auth.auth().currentUser?.uid as? String ?? ""{
                    Text("MY")
                        .foregroundColor(.white)
                        .font(.caption2)
                        .padding(5)
                        .background(Circle().foregroundColor(.blue))
                }
                
                Spacer()
                
                Text(convertTime())
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer().frame(height : 10)
            
            HStack{
                Text(data.last_msg)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                
                Spacer()
            }
        }.padding(20)
            .background(RoundedRectangle(cornerRadius: 15.0)
                            .shadow(radius: 2, x: 0, y: 2)
                            .foregroundColor(.btn_color))
        .onAppear(perform: {
            self.setProfiles()
            self.setProfileBG()
        })
    }
}

//struct ChatListModel_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatListModel(data : ChatListDataModel(docId: "", SOZIPName: "SOZIP Name", currentPeople: 1, last_msg: "hi", participants: [:], status: "", payMethod: [:], transactionMethod: [:], profiles: ["":"pig,bg_2"], color: .accent, last_msg_time: "21/08/23 23:09:27.2500"))
//    }
//}
