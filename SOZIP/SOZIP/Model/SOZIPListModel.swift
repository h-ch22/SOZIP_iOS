//
//  SOZIPListModel.swift
//  SOZIPListModel
//
//  Created by 하창진 on 2021/08/01.
//

import SwiftUI

struct SOZIPListModel: View {
    let data : SOZIPDataModel

    var body: some View {
        VStack{
            Rectangle()
                .fill(data.SOZIP_Color)
                .frame(height : 3)
                .edgesIgnoringSafeArea(.horizontal)
            
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
                Image("ic_store")
                    .resizable()
                    .frame(width : 20, height : 20)
                    .foregroundColor(.txt_color)
                
                Text(data.store)
                    .font(.caption)
                    .foregroundColor(.txt_color)

                Spacer()

                Image(systemName: "clock.fill")
                    .foregroundColor(.txt_color)
            }
            
            HStack{
                Image(systemName: "location.fill.viewfinder")
                    .resizable()
                    .frame(width : 20, height : 20)
                    .foregroundColor(.txt_color)
                
                Text(data.location_description)
                    .font(.caption)
                    .foregroundColor(.txt_color)
                
                Spacer()

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
        .background(RoundedRectangle(cornerRadius: 15.0).shadow(radius: 5).foregroundColor(.btn_color))
        
    }
}

//struct SOZIPListModel_Previews: PreviewProvider {
//    static var previews: some View {
//        SOZIPListModel(data: SOZIPDataModel(tags: [], SOZIPName: "title", currentPeople: 0, location_description: "location", SOZIP_Color: .sozip_bg_1, store : "store", time: Date()))
//    }
//}
