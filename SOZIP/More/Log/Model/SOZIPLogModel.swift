//
//  SOZIPLogView.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/04.
//

import SwiftUI

struct SOZIPLogModel: View {
    let data : SOZIPDataModel

    var body: some View {
        VStack{
            HStack{
                Text(data.SOZIPName)
                    .fontWeight(.semibold)
                    .foregroundColor(.txt_color)
                
                Spacer()
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
        }
    }
}
