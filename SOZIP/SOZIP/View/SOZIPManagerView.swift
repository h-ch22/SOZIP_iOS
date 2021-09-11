//
//  SOZIPManagerView.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/04.
//

import SwiftUI
import Firebase

struct SOZIPManagerView: View {
    @State private var key : [String] = []
    
    let model : SOZIPDataModel
    let uid = Auth.auth().currentUser?.uid ?? ""
    
    func getProfile(uid : String) -> String{
        var profile = "🐥"
        
        let userProfile = model.profile[uid] ?? ""
        
        if userProfile != ""{
            let profile_split = userProfile.components(separatedBy: ",")
            
            switch profile_split[0]{
            case "pig" :
                profile = "🐷"
                
            case "rabbit":
                profile = "🐰"
                
            case "tiger" :
                profile = "🐯"
                
            case "monkey" :
                profile = "🐵"
                
            case "chick" :
                profile = "🐥"
                
            default :
                profile = "🐥"
            }
        }
        
        return profile
    }
    
    func getProfileBG(uid : String) -> Color{
        var profile_bg : Color = .sozip_bg_1
        
        let userProfile = model.profile[uid] ?? ""
        
        if userProfile != ""{
            let profile_split = userProfile.components(separatedBy: ",")
            
            switch profile_split[1]{
            case "bg_1":
                profile_bg = .sozip_bg_1
                
            case "bg_2":
                profile_bg = .sozip_bg_2
                
            case "bg_3":
                profile_bg = .sozip_bg_3
                
            case "bg_4":
                profile_bg = .sozip_bg_4
                
            case "bg_5":
                profile_bg = .sozip_bg_5
                
            default:
                profile_bg = .sozip_bg_1
                
            }
        }
        
        return profile_bg
    }
    
    var body: some View {
        VStack{
            
            HStack{
                Text("참여자 정보")
                    .fontWeight(.semibold)
                
                Spacer()
            }
            
            Spacer().frame(height : 20)
            
            if model.currentPeople <= 1{
                Text("아직 이 소집에 참여자가 없어요!")
                    .foregroundColor(.gray)
            }
            
            else{
                if key.indices.count <= 3{
                    HStack{
                        ForEach(key.indices, id : \.self){row in
                            if key[row] != uid{
                                VStack{
                                    Text(getProfile(uid : key[row]))
                                        .modifier(FittingFontSizeModifier())
                                        .padding(5)
                                        .frame(width : 50, height : 50)
                                        .background(Circle().foregroundColor(getProfileBG(uid : key[row])))
                                    
                                    Text(model.participants[key[row]] ?? "알 수 없음")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                }.padding(20)
                                
                                Spacer().frame(width : 15)
                                
                            }
                            
                        }
                    }
                }
                
                else{
                    ForEach(0..<key.indices.count / 3, id : \.self){row in
                        VStack {
                            HStack{
                                ForEach(0..<3){column in
                                    if key[column] != uid{
                                        VStack{
                                            Text(getProfile(uid : key[column]))
                                                .modifier(FittingFontSizeModifier())
                                                .padding(5)
                                                .frame(width : 50, height : 50)
                                                .background(Circle().foregroundColor(getProfileBG(uid : key[column])))
                                            
                                            Text(model.participants[key[column]] ?? "알 수 없음")
                                                .font(.caption)
                                                .fontWeight(.semibold)
                                        }
                                        .padding(20)
                                        
                                    }
                                    
                                    Spacer().frame(width : 15)
                                    
                                }
                            }
                        }
                    }
                }
                
                
            }
            
        }.onAppear(perform: {
            key = Array(model.participants.keys)
            
            print(key)
        })
    }
}
