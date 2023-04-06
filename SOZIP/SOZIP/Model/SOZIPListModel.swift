//
//  SOZIPListModel.swift
//  SOZIPListModel
//
//  Created by 하창진 on 2021/08/01.
//

import SwiftUI
import Firebase

struct SOZIPListModel: View {
    let data : SOZIPDataModel
    var helper = SOZIPHelper()
    @State private var calendar = Calendar.current
    @State private var date : Date? = nil
    @State private var timeRemaining : String = ""
    @State private var minute : Int = 0
    @State private var seconds : Int = 0
    @State private var remain = ""
    @State private var isImminent = false
    @State private var time = ""
    
    let timer = Timer.publish(every: 1, on : .main, in: .common).autoconnect()
    
    private func calcTime(){
        if data.status == ""{
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "yyyy. MM. dd. kk:mm:ss"
            
            let endDate_tmp = dateFormatter.string(from: data.time)
            let startDate_tmp = dateFormatter.string(from: Date())
            
            let endDate = dateFormatter.date(from: endDate_tmp)
            let startDate = dateFormatter.date(from: startDate_tmp)
            
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute, .second]
            formatter.unitsStyle = .positional
            
            remain = formatter.string(from : startDate!, to : endDate!)!
            
            let remainTime = Int((endDate?.timeIntervalSince(startDate!))!) / 60
            
            if remainTime <= 15{
                isImminent = true
            }
        }
        
    }
    
    var body: some View {
        VStack{
            HStack{                
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(isImminent ? .white : data.color)
                    .frame(width : 5, height : 30)
                
                Image(systemName : data.type == .DELIVERY ? "bicycle.circle.fill" : "takeoutbag.and.cup.and.straw.fill")
                    .foregroundColor(isImminent ? .white : .txt_color)
                    .multilineTextAlignment(.leading)
                
                Text(data.SOZIPName)
                    .fontWeight(.semibold)
                    .foregroundColor(isImminent ? .white : .txt_color)
                    .multilineTextAlignment(.leading)
                
                if data.Manager == Auth.auth().currentUser?.uid{
                    Text("MY")
                        .foregroundColor(.white)
                        .font(.caption)
                        .padding(5)
                        .background(Circle().foregroundColor(.blue))
                }
                
                Spacer()
                
                Image(systemName: "person.2.fill")
                    .resizable()
                    .frame(width : 20, height : 14)
                    .foregroundColor(isImminent ? .white : .txt_color)
                
                Text(String(data.currentPeople) + "/" + String(data.firstCome + 1))
                    .foregroundColor(isImminent ? .white : .txt_color)
            }
            
            HStack{
                Image(systemName: "location.fill")
                    .resizable()
                    .frame(width : 15, height : 15)
                    .foregroundColor(isImminent ? .white : .gray)
                
                VStack {
                    HStack {
                        Text(data.location_description)
                            .font(.caption)
                            .foregroundColor(isImminent ? .white : .gray)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                    }.isHidden(data.location_description == "")
                    
                    HStack {
                        Text(data.address)
                            .font(.caption)
                            .foregroundColor(isImminent ? .white : .gray)
                            .fontWeight(.light)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                    }
                }
                
                Spacer()
                
                Image(systemName: "clock.fill")
                    .resizable()
                    .frame(width : 15, height : 15)
                    .foregroundColor(isImminent ? .white : .accent)
                    .isHidden(data.status != "")
                
                Spacer().frame(width : 5)
                
                Text(remain)
                    .foregroundColor(isImminent ? .white : .accent)
                    .font(.caption)
                    .isHidden(data.status != "")
                    .onReceive(timer){time in
                        calcTime()
                    }
            }
            
            HStack{
                Text(data.category ?? "")
                    .padding(10)
                    .font(.caption)
                    .foregroundColor(isImminent ? data.color : .accent)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(isImminent ? .white : .clear)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius : 10)
                            .stroke(lineWidth : 1)
                            .foregroundColor(isImminent ? .clear : .accent)
                    )
                    .isHidden(data.category == "")
                
                Spacer()
                
                Text(time)
                    .font(.caption)
                    .foregroundColor(isImminent ? .white : .gray)
            }
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 15.0)
                        .shadow(radius: 2, x: 0, y: 2)
                        .foregroundColor(isImminent ? data.color : .btn_color))
        .onAppear(perform: {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM.dd kk:mm"
            
            time = formatter.string(from: data.time)
        })
    }
}

//struct SOZIPListModel_Previews: PreviewProvider {
//    static var previews: some View {
//        SOZIPListModel(data: SOZIPDataModel(tags: [], SOZIPName: "title", currentPeople: 0, location_description: "location", SOZIP_Color: .sozip_bg_1, store : "store", time: Date()))
//    }
//}
