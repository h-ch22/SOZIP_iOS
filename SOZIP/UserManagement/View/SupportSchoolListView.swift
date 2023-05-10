//
//  SupportSchoolListView.swift
//  SOZIP
//
//  Created by Changjin Ha on 2023/04/09.
//

import SwiftUI

struct SupportSchoolListView: View {
    @State private var schoolList = ["강원대학교", "경북대학교", "경상국립대학교", "부산대학교", "서울대학교", "전남대학교", "전북대학교", "제주대학교", "충남대학교", "충북대학교"]
    
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.backgroundColor.edgesIgnoringSafeArea(.all)
                
                ScrollView{
                    VStack{
                        Image("appstore")
                            .resizable()
                            .frame(width : 150, height : 150)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(radius: 5)
                        
                        Text("소집 : SOZIP 지원 대상 학교에 관하여 알아보기")
                            .font(.title)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.txt_color)
                        
                        Spacer().frame(height : 20)
                        
                        HStack{
                            Text("지원 대상 학교")
                                .font(.headline)
                            
                            Spacer()
                        }
                        
                        Spacer().frame(height : 10)
                        
                        ForEach(schoolList, id : \.self){school in
                            HStack {
                                Text("· \(school)")
                                
                                Spacer()
                            }
                        }
                        
                    }.padding(20)
                }
            }.navigationTitle(Text("지원 대상 학교"))
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: Button("닫기"){
                    self.presentationMode.wrappedValue.dismiss()
                })
        }

    }
}

struct SupportSchoolListView_Previews: PreviewProvider {
    static var previews: some View {
        SupportSchoolListView()
    }
}
