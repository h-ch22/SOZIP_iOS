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
            Rectangle()
                .fill(data.SOZIP_Color)
                .frame(height : 3)
                .edgesIgnoringSafeArea(.horizontal)
            
            HStack{
                Text(data.SOZIPName)
                    .fontWeight(.semibold)
                    .foregroundColor(.txt_color)
                
                Spacer()
                
                NavigationLink(destination: EmptyView()){
                    Image(systemName: "exclamationmark.bubble.fill")
                        .foregroundColor(.red)
                }
                    
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
