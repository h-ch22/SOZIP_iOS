//
//  SOZIPLogView.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/04.
//

import SwiftUI
import Firebase

struct SOZIPLogModel: View {
    let data : SOZIPDataModel

    var body: some View {
        VStack{
            HStack{
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(data.color)
                    .frame(width : 5, height : 30)
                
                Text(data.SOZIPName)
                    .fontWeight(.semibold)
                    .foregroundColor(.txt_color)
                    .multilineTextAlignment(.leading)
                
                if data.Manager == Auth.auth().currentUser?.uid{
                    Text("MY")
                        .foregroundColor(.white)
                        .font(.caption)
                        .padding(5)
                        .background(Circle().foregroundColor(.blue))
                }
                
                Spacer()
                
            }
            
            HStack{
                Image(systemName: "location.fill")
                    .resizable()
                    .frame(width : 15, height : 15)
                    .foregroundColor(.gray)
                
                VStack {
                    HStack {
                        Text(data.location_description)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                    }.isHidden(data.location_description == "")
                    
                    HStack {
                        Text(data.address)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .fontWeight(.light)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                    }
                }
                
                Spacer()
                
            }
            
            HStack{
                Text(data.category ?? "")
                    .padding(10)
                    .font(.caption)
                    .foregroundColor(.accent)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.clear)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius : 10)
                            .stroke(lineWidth : 1)
                            .foregroundColor(.accent)
                    )

                Spacer()
            }.isHidden(data.category == "")
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 15.0)
                        .shadow(radius: 2, x: 0, y: 2)
                        .foregroundColor(.btn_color))
    }
}
