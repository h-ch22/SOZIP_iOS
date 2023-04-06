//
//  DutchPayView.swift
//  SOZIP
//
//  Created by Changjin Ha on 2023/04/05.
//

import SwiftUI

struct DutchPayView: View {
    @State private var payType : PayTypeModel = .DUTCH_PAY
    @State private var fees = ""
    @State private var isFieldUsing = false
    let data : SOZIPDataModel
    
    private func profileToEmoji(profile : String) -> String{
        switch profile{
        case "pig" :
            return"🐷"
            
        case "rabbit":
            return "🐰"

        case "tiger" :
            return "🐯"

        case "monkey" :
            return "🐵"
            
        case "chick" :
            return "🐥"
            
        default:
            return "🐥"
        }
    }
    
    private func stringToBGColor(color : String) -> Color{
        switch color{
        case "bg_1":
            return Color.sozip_bg_1
            
        case "bg_2":
            return Color.sozip_bg_2
            
        case "bg_3":
            return Color.sozip_bg_3
            
        case "bg_4":
            return Color.sozip_bg_4
            
        case "bg_5":
            return Color.sozip_bg_5
            
        default:
            return Color.sozip_bg_1
        }
    }
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.backgroundColor.edgesIgnoringSafeArea(.all)
                
                VStack{
                    Group{
                        Image(systemName : "wonsign.circle.fill")
                            .resizable()
                            .frame(width : 100, height : 100)
                            .foregroundColor(.accent)
                        
                        Text("정산 방식을 선택하세요.")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.txt_color)
                        
                        Spacer().frame(height : 20)
                        
                        HStack {
                            Image(systemName : "wonsign.circle.fill")
                                .foregroundColor(isFieldUsing ? Color.accent : Color.txt_color)

                            TextField("전체 요금", text:$fees, onEditingChanged: {(editing) in
                                if editing{
                                    isFieldUsing = true
                                }
                                
                                else{
                                    isFieldUsing = false
                                }
                            }).keyboardType(.numberPad)
                            
                        }.foregroundColor(isFieldUsing ? Color.accent : Color.txt_color)
                            .padding(20)
                            .background(RoundedRectangle(cornerRadius: 10)
                                            .foregroundColor(.btn_color)
                                            .shadow(radius: 5))
                        .frame(width : 300)
                        
                        Spacer().frame(height : 20)
                        
                        HStack{
                            Button(action : {
                                payType = .DUTCH_PAY
                            }){
                                VStack{
                                    Image(systemName : "person.3.fill")
                                        .foregroundColor(payType == .DUTCH_PAY ? .white : .accent)
                                    
                                    Text("더치페이")
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .foregroundColor(payType == .DUTCH_PAY ? .white : .accent)

                                    Text("전체 금액을 참가자 수로 나눈만큼 정산합니다.")
                                        .font(.caption)
                                        .foregroundColor(payType == .DUTCH_PAY ? .white : .gray)

                                }.padding(20)
                                    .background(RoundedRectangle(cornerRadius : 15).foregroundColor(payType == .DUTCH_PAY ? .accent : .btn_color).shadow(radius : 5))
                            }
                            
                            Button(action : {
                                payType = .SEPERATE
                            }){
                                VStack{
                                    Image(systemName : "person.2.slash.fill")
                                        .foregroundColor(payType == .SEPERATE ? .white : .accent)
                                    
                                    Text("개별 정산")
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .foregroundColor(payType == .SEPERATE ? .white : .accent)

                                    Text("참가자마다 별도의 금액으로 정산합니다.")
                                        .font(.caption)
                                        .foregroundColor(payType == .SEPERATE ? .white : .gray)

                                }.padding(20)
                                    .background(RoundedRectangle(cornerRadius : 15).foregroundColor(payType == .SEPERATE ? .accent : .btn_color).shadow(radius : 5))
                            }
                        }
                    }
                    
                    Group{
                        if fees != "" && fees != "0" && payType == .DUTCH_PAY{
                            Spacer().frame(height : 20)

                            Text("소집 참가자들에게 \(Int(fees) ?? 1 / data.currentPeople)원을 정산 요청합니다.")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }

                        
                        Spacer().frame(height : 20)
                        
                        Button(action : {}){
                            HStack{
                                Text("계좌 정보 전송")
                                    .foregroundColor(.white)
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                            }.padding(20)
                            .frame(width : 300)
                            .background(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).shadow(radius: 5))
                            .disabled(self.fees.isEmpty)
                            
                        }
                    }
                }.padding(20)
                    .padding(20)
                    .background(Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
                .navigationBarTitle("정산 방식 선택")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: Button("닫기"){
                    
                })
            }
 
        }


    }
}

struct DutchPayView_Previews: PreviewProvider {
    static var previews: some View {
        DutchPayView(data : SOZIPDataModel(docId: "", SOZIPName: "", currentPeople: 2, location_description: "", time: Date(), Manager: "", participants: ["T75V2SOfYfTfPshuanFIw4XzP9y2" : "Changjin", "1" : "Changjin2"], location: "", address: "", status: "", color: .sozip_bg_1, account: "KB 국민은행 79620101653747", profile: ["T75V2SOfYfTfPshuanFIw4XzP9y2":"chick,bg_1", "1" : "pig,bg_3"], url: "", category: "", firstCome: 2, type: .DELIVERY))
    }
}
