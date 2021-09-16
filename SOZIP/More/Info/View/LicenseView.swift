//
//  LicenseView.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/27.
//

import SwiftUI

struct LicenseView: View {
    @Binding var licenseType : LicenseType
    @State private var license : String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView{
            VStack{
                switch licenseType{
                case .EULA :
                    PDFViewer(url : Bundle.main.url(forResource: "EULA", withExtension: "pdf")!)

                case .location:
                    PDFViewer(url : Bundle.main.url(forResource: "EULA", withExtension: "pdf")!)

                case .privacy:
                    PDFViewer(url : Bundle.main.url(forResource: "PrivacyLicense", withExtension: "pdf")!)

                case .marketing:
                    PDFViewer(url : Bundle.main.url(forResource: "EULA", withExtension: "pdf")!)
                }
            }.navigationBarTitle(self.license, displayMode: .inline)
            
            .navigationBarItems(trailing: Button("닫기"){
                self.presentationMode.wrappedValue.dismiss()
            })
            
            .onAppear(perform: {
                switch licenseType{
                case .EULA:
                    self.license = "최종 사용권 계약서"
                    
                case .location:
                    self.license = "위치 정보 이용 약관"
                    
                case .privacy:
                    self.license = "개인정보 처리 방침"
                    
                case .marketing:
                    self.license = "마케팅 정보 수신"
                }
            })
        }.accentColor(.accent)
    }
}

struct LicenseView_Previews: PreviewProvider {
    static var previews: some View {
        LicenseView(licenseType: .constant(.EULA))
    }
}
