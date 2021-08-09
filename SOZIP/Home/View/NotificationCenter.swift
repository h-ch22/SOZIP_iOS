//
//  NotificationCenter.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/28.
//

import SwiftUI

struct NotificationCenter: View {
    @State private var receiveMarketing : Bool = false
    
    var body: some View {
        ZStack(alignment : .top) {
            Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            VStack{
                Spacer().frame(height : 20)
                
                HStack{
                    Spacer()
                    
                    Toggle(isOn: $receiveMarketing, label: {
                        Text("마케팅 알림 받기")
                    }).toggleStyle(SwitchToggleStyle(tint : Color.accent))
                }
            }.padding([.horizontal],20)
            .navigationBarTitle(Text("알림"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {}){
                Image(systemName: "trash")
            })
            
            
        }
        
    }
}

struct NotificationCenter_Previews: PreviewProvider {
    static var previews: some View {
        NotificationCenter()
    }
}
