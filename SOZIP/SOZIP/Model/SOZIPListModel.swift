//
//  SOZIPListModel.swift
//  SOZIPListModel
//
//  Created by 하창진 on 2021/08/01.
//

import SwiftUI

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
    
    let timer = Timer.publish(every: 1, on : .main, in: .common).autoconnect()
    
    private func calcTime(){
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy. MM. dd. kk:mm:ss"

        let endDate_tmp = dateFormatter.string(from: data.time)
        let startDate_tmp = dateFormatter.string(from: Date())

        let endDate = dateFormatter.date(from: endDate_tmp)
        let startDate = dateFormatter.date(from: startDate_tmp)
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .short
        
        remain = formatter.string(from : startDate!, to : endDate!)!
        
        let remainTime = Int((endDate?.timeIntervalSince(startDate!))!) / 60
        
        if remainTime <= 15{
            isImminent = true
        }
        
        if Int((endDate?.timeIntervalSince(startDate!))!) < 0{
            helper.stopSOZIP(docId: data.docId){result in
                guard let result = result else{return}
            }
        }
    }
    
    var body: some View {
        VStack{
            HStack{
                Text(data.SOZIPName)
                    .fontWeight(.semibold)
                    .foregroundColor(.txt_color)
                
                Spacer()
                
                Image(systemName: "person.2.fill")
                    .foregroundColor(.txt_color)
                
                Text(String(data.currentPeople))
                    .foregroundColor(.txt_color)
                    
            }
            
            HStack{
                Image(systemName: "location.fill")
                    .resizable()
                    .frame(width : 20, height : 20)
                    .foregroundColor(.txt_color)
                
                Text(data.location_description)
                    .font(.caption)
                    .foregroundColor(.txt_color)
                
                Spacer()

                Text(remain)
                    .foregroundColor(isImminent ? .white : .accent)
                    .onReceive(timer){time in
                        calcTime()
                    }
            }
            
            HStack{
                ForEach(0..<data.tags.count){index in
                    Text(data.tags[index])
                        .padding(10)
                        .font(.caption)
                        .foregroundColor(.white)
                        .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.accent).shadow(radius: 3))
                }
                
                Spacer()
            }
        }.padding(20)
        .background(RoundedRectangle(cornerRadius: 15.0).shadow(radius: 5).foregroundColor(isImminent ? .accent : .btn_color))
    }
}

//struct SOZIPListModel_Previews: PreviewProvider {
//    static var previews: some View {
//        SOZIPListModel(data: SOZIPDataModel(tags: [], SOZIPName: "title", currentPeople: 0, location_description: "location", SOZIP_Color: .sozip_bg_1, store : "store", time: Date()))
//    }
//}
