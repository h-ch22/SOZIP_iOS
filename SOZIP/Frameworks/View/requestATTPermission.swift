//
//  requestATTPermission.swift
//  requestATTPermission
//
//  Created by 하창진 on 2021/08/03.
//

import SwiftUI
import AppTrackingTransparency
import AdSupport

struct requestATTPermission: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack{
                Image(systemName: "exclamationmark.shield.fill")
                    .resizable()
                    .frame(width: 80, height: 100, alignment: .center)
                    .foregroundColor(.accent)
                
                Text("소집 : SOZIP에서 고객님께 맞춤 정보를 추천해드립니다.")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.txt_color)
                    .multilineTextAlignment(.center)
                
                Spacer().frame(height : 40)
                
                Text("고객님의 광고 활동 정보를 광고 서비스 제공업체와 공유할지 결정하세요.\n정보는 모두 익명으로 제공되며, 거부 시 랜덤으로 광고가 표시됩니다.")
                    .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                
                Spacer().frame(height : 40)

                Button(action : {
                    ATTrackingManager.requestTrackingAuthorization{(status) in
                        switch status{
                        case .authorized:
                            self.presentationMode.wrappedValue.dismiss()
                            
                        case .denied:
                            self.presentationMode.wrappedValue.dismiss()
                            
                        case .notDetermined:
                            break
                            
                        case .restricted:
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }){
                    HStack {
                        Text("계속")
                            .foregroundColor(.white)
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white)
                    }.padding(20)
                        .padding([.horizontal], 80)
                    .background(RoundedRectangle(cornerRadius: 15).shadow(radius: 5))
                }
            }.padding(20)
        }
    }
}

struct requestATTPermission_Previews: PreviewProvider {
    static var previews: some View {
        requestATTPermission()
    }
}
