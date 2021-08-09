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
    let uid = Auth.auth().currentUser?.uid as? String ?? ""
    
    var body: some View {
        VStack{
            if model.Manager != uid{
                EmptyView()
            }
            
            else{
                HStack{
                    Text("소집 정보")
                        .fontWeight(.semibold)

                    Spacer()
                }
                
                Spacer().frame(height : 20)

                if model.currentPeople <= 1{
                    Text("아직 이 소집에 참여자가 없어요!")
                        .foregroundColor(.gray)
                }
                
                else{
                    ForEach(key.indices, id : \.self){index in
                        if key[index] != uid{
                            VStack{
                                HStack{
                                    Image("profile_burger")
                                        .resizable()
                                        .frame(width : 20, height : 20)
                                        
                                    Text(model.participants[key[index]] as? String ?? "알 수 없음")
                                        .fontWeight(.semibold)
                                    
                                    Spacer()
                                }
                                
                                Spacer().frame(height : 10)

                                HStack{
                                    if model.transactionMethod[key[index]] as? String ?? "" == "Meet"{
                                        Text("거래 방식 : 소집 장소에서 만나요!")
                                            .font(.caption)
                                        
                                        Spacer()
                                    }
                                    
                                    else{
                                        Text("거래 방식 : \(model.transactionMethod[key[index]] as? String ?? "")에 놓고 가주세요!")
                                            .font(.caption)
                                        
                                        Spacer()
                                    }
                                }
                                
                                Spacer().frame(height : 10)

                                HStack{
                                    if model.payMethod[key[index]] as? String ?? "" == "bank"{
                                        Text("결제 방식 : 방장 계좌로 계좌 이체할게요!")
                                            .font(.caption)
                                        
                                        Spacer()
                                    }
                                    
                                    else if model.payMethod[key[index]] as? String ?? "" == "cache"{
                                        Text("결제 방식 : 만나서 현금을 드릴게요!")
                                            .font(.caption)
                                        
                                        Spacer()
                                    }
                                    
                                    else if model.payMethod[key[index]] as? String ?? "" == "private"{
                                        Text("결제 방식 : 안전 결제할게요!")
                                            .font(.caption)
                                        
                                        Spacer()
                                    }
                                }
                            }
                            .padding(20).background(RoundedRectangle(cornerRadius: 15.0).shadow(radius: 5).foregroundColor(.btn_color))
                        }
                        
                    }
                }
                    
            }
        }.onAppear(perform: {
            key = Array(model.participants.keys)
        })
    }
}
