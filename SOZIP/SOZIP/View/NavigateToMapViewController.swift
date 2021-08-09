//
//  NavigateToMapViewController.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/29.
//

import Foundation
import SwiftUI
import NMapsMap

struct NavigateToMapViewController : View{
    @State private var description = ""
    @State private var isDescriptionEditing = false
    
    @ObservedObject var receiver : SOZIPLocationReceiver
    @Environment(\.presentationMode) var presentationMode

    var body: some View{
        ZStack {
            loadMapView(receiver: receiver)
            
            VStack {
                Spacer()
                
                VStack{
                    Text("주소 : \(receiver.address)")
                        .multilineTextAlignment(.center)
                    
                    Spacer().frame(height : 20)
                    
                    HStack {
                        Image(systemName: "location.fill.viewfinder")
                            .resizable()
                            .frame(width : 20, height : 20)
                        
                        TextField("설명을 입력해주세요! (예 : 새빛관 앞)", text:$description, onEditingChanged: {(editing) in
                            if editing{
                                isDescriptionEditing = true
                            }
                            
                            else{
                                isDescriptionEditing = false
                            }
                        })
                    }
                    .foregroundColor(isDescriptionEditing ? Color.accent : Color.txt_color)
                    .padding(20)
                    .padding([.horizontal], 30)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.btn_color).shadow(radius: 5)
                                .padding([.horizontal],20))
                    
                    Spacer().frame(height : 20)

                    Button(action : {
                        receiver.description = description
                        self.presentationMode.wrappedValue.dismiss()
                    }){
                        HStack{
                            Text("설정 완료")
                                .foregroundColor(.white)
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                        }.padding()
                        .padding([.horizontal], 60)
                        .background(RoundedRectangle(cornerRadius: 15).shadow(radius: 5))
                    }
                }.padding()
                .background(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).foregroundColor(.backgroundColor).opacity(0.8).shadow(radius: 5))

            }
        }
        .onAppear(perform: {
            receiver.address.removeAll()
            receiver.description.removeAll()
            receiver.location.removeAll()
        })
    }
}

struct loadMapView : UIViewControllerRepresentable{
    typealias UIViewControllerType = MapView
    var receiver : SOZIPLocationReceiver
    
    func makeUIViewController(context: Context) -> MapView {
        return MapView(receiver : receiver)
    }
    
    func updateUIViewController(_ uiViewController: MapView, context: Context) {
    }
}
