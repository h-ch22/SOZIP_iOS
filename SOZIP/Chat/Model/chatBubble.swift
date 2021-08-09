//
//  chatBubble.swift
//  chatBubble
//
//  Created by 하창진 on 2021/08/04.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct chatBubble: View {
    let message : String
    let sender : String
    let color : Color
    let type : String
    let participants : [String : String]
    let index : Int?
    let docId : String
    let items : [String?]
    
    var body: some View {
        if type == "text"{
            if sender == Auth.auth().currentUser?.uid as? String ?? ""{
                Text(message)
                    .padding(10)
                    .foregroundColor(.white)
                    .background(Color.gray)
                    .cornerRadius(10)
            }
            
            else{
                VStack{
                    HStack{
                        Image("profile_burger")
                            .resizable()
                            .frame(width : 20, height : 20)
                        
                        Spacer().frame(width : 10)
                        
                        Text(participants[sender] ?? "")
                            .foregroundColor(.txt_color)
                            .font(.caption)
                        
                        Spacer()
                    }
                    
                    HStack{
                        Text(message)
                            .padding(10)
                            .foregroundColor(.white)
                            .background(color)
                            .cornerRadius(10)
                        
                        Spacer()
                    }
                    
                }
                
            }
        }
        
        else if type == "participate"{
            if sender == Auth.auth().currentUser?.uid as? String ?? ""{
                VStack {
                    Text(message)
                        
                    
                    Image("profile_burger")
                        .resizable()
                        .frame(width : 40, height : 40)
                }.padding(10)
                .foregroundColor(.white)
                .background(Color.gray)
                .cornerRadius(10)
            }
            
            else{
                VStack{
                    HStack{
                        Image("profile_burger")
                            .resizable()
                            .frame(width : 20, height : 20)
                        
                        Spacer().frame(width : 10)
                        
                        Text(participants[sender] ?? "")
                            .foregroundColor(.txt_color)
                            .font(.caption)
                        
                        Spacer()
                    }
                    
                    HStack{
                        VStack {
                            Text(message)
                                
                            
                            Image("profile_burger")
                                .resizable()
                                .frame(width : 40, height : 40)
                        }.padding(10)
                        .foregroundColor(.white)
                        .background(color)
                        .cornerRadius(10)
                        
                        Spacer()
                    }
                    
                }
                
            }
        }
        
        else if type == "image"{
            if sender == Auth.auth().currentUser?.uid ?? ""{
                if index == 1{
                    HStack {
                        WebImage(url : URL(string : items[0]!))
                            .resizable()
                        .frame(width : 200, height : 200)
                    }.padding(10)
                        .foregroundColor(.white)
                        .background(Color.gray)
                        .cornerRadius(10)
                }
                
                
                else if index! == 2 && index != nil{
                    HStack {
                        ForEach(0..<items.count, id : \.self){index in
                            WebImage(url:URL(string: items[index]!))
                                .resizable()
                                .scaledToFit()
                                .frame(width : 100)

                        }
                    }.padding(10)
                        .foregroundColor(.white)
                        .background(Color.gray)
                        .cornerRadius(10)
                }

                else if index! >= 3 && index! <= 6 && index != nil{
                    VStack {
                        HStack {
                            ForEach(0..<3, id : \.self){index in
                                WebImage(url:URL(string: items[index]!))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width : 100)

                            }
                        }

                        HStack {
                            ForEach(3..<items.count, id : \.self){index in
                                WebImage(url:URL(string: items[index]!))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width : 100)

                            }
                        }
                    }.padding(10)
                        .foregroundColor(.white)
                        .background(Color.gray)
                        .cornerRadius(10)
                }

                else if index! > 7 && index! <= 10 && index != nil{
                    VStack {
                        HStack {
                            ForEach(0..<3, id : \.self){index in
                                WebImage(url:URL(string: items[index]!))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width : 100)

                            }
                        }

                        HStack {
                            ForEach(3..<6, id : \.self){index in
                                WebImage(url:URL(string: items[index]!))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width : 100)

                            }
                        }

                        HStack {
                            ForEach(6..<items.count, id : \.self){index in
                                WebImage(url:URL(string: items[index]!))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width : 100)

                            }
                        }
                    }.padding(10)
                        .foregroundColor(.white)
                        .background(Color.gray)
                        .cornerRadius(10)
                }
            }
            
            else{
                VStack{
                    HStack{
                        Image("profile_burger")
                            .resizable()
                            .frame(width : 20, height : 20)
                        
                        Spacer().frame(width : 10)
                        
                        Text(participants[sender] ?? "")
                            .foregroundColor(.txt_color)
                            .font(.caption)
                        
                        Spacer()
                    }
                    
                    HStack{
                        if index == 1{
                            HStack {
                                WebImage(url : URL(string : items[0]!))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width : 200, height : 200)
                            }.padding(10)
                                .foregroundColor(.white)
                                .background(color)
                                .cornerRadius(10)
                        }
                        
                        else if index! == 2 && index != nil{
                            HStack {
                                ForEach(0..<items.count, id : \.self){index in
                                    WebImage(url:URL(string: items[index]!))
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width : 100)

                                }
                            }.padding(10)
                                .foregroundColor(.white)
                                .background(color)
                                .cornerRadius(10)
                        }

                        else if index! >= 3 && index! <= 6 && index != nil{
                            VStack {
                                HStack {
                                    ForEach(0..<3, id : \.self){index in
                                        WebImage(url:URL(string: items[index]!))
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width : 100)

                                    }
                                }

                                HStack {
                                    ForEach(3..<items.count, id : \.self){index in
                                        WebImage(url:URL(string: items[index]!))
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width : 100)

                                    }
                                }
                            }.padding(10)
                                .foregroundColor(.white)
                                .background(color)
                                .cornerRadius(10)
                        }

                        else if index! > 7 && index! <= 10 && index != nil{
                            VStack {
                                HStack {
                                    ForEach(0..<3, id : \.self){index in
                                        WebImage(url:URL(string: items[index]!))
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width : 100)

                                    }
                                }

                                HStack {
                                    ForEach(3..<6, id : \.self){index in
                                        WebImage(url:URL(string: items[index]!))
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width : 100)

                                    }
                                }

                                HStack {
                                    ForEach(6..<items.count, id : \.self){index in
                                        WebImage(url:URL(string: items[index]!))
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width : 100)

                                    }
                                }
                            }.padding(10)
                                .foregroundColor(.white)
                                .background(color)
                                .cornerRadius(10)
                        }
                        
                        Spacer()
                    }
                    
                }
            }
        }

        
    }
}
