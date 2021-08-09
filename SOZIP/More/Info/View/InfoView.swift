//
//  InfoView.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/30.
//

import SwiftUI

struct InfoView: View {
    @State private var latest = ""
    @ObservedObject var helper : VersionManager
    
    var body: some View {
        let version: String? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        
        ScrollView{
            ZStack{
                Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
                VStack{
                    Spacer().frame(height : 20)
                    
                    Group {
                        HStack{
                            Image("appstore")
                                .resizable()
                                .frame(width : 100, height : 100)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .shadow(radius: 2, x:0, y:2)
                            
                            
                            VStack(alignment : .leading){
                                Text("소집 : SOZIP")
                                    .foregroundColor(.txt_color)
                                    .font(.title)
                                    .fontWeight(.semibold)
                                
                                Text("현재 버전 : " + version!)
                                    .foregroundColor(.txt_color)
                                
                                Text("최신 버전 : " + latest)
                                    .foregroundColor(.txt_color)
                                
                                Spacer().frame(height : 10)

                                if latest != "" && latest != "버전 정보를 불러올 수 없습니다."{
                                    if latest != version!{
                                        HStack{
                                            Image(systemName : "xmark")
                                                .foregroundColor(.red)
                                            
                                            Text("최신 버전이 아닙니다.")
                                                .foregroundColor(.red)
                                        
                                        }
                                        
                                        Spacer().frame(height : 10)

                                        Button(action: {}){
                                            HStack{
                                                Text("업데이트")
                                                    .foregroundColor(.white)
                                                
                                                Image(systemName : "chevron.right")
                                                    .foregroundColor(.white)
                                            }
                                        }.padding(10)
                                        .background(RoundedRectangle(cornerRadius : 10).foregroundColor(.accent))
                                    }
                                    
                                    else{
                                        HStack{
                                            Image(systemName : "checkmark")
                                                .foregroundColor(.green)
                                            
                                            Text("최신 버전입니다.")
                                                .foregroundColor(.green)
                                        }
                                    }
                                }
                                
                                else{
                                    
                                }
                            }
                        }.padding(20)
                        .padding([.vertical], 10)
                        .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btn_color).shadow(radius: 2, x:0, y:2))
                    }
                    
                    Spacer().frame(height : 20)

                    Group {
                        NavigationLink(destination: EmptyView()){
                            HStack{
                                Image("ic_eula")
                                    .resizable()
                                    .frame(width: 30, height: 30, alignment: .leading)
                                    .foregroundColor(.btn_dark)
                                
                                Text("서비스 이용 약관 읽기")
                                    .foregroundColor(.txt_color)
                                    .fontWeight(.semibold)
                                
                                Spacer()
                            }.padding(20)
                            .padding([.vertical], 10)
                            .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btn_color).shadow(radius: 2, x:0, y:2))
                        }
                        
                        Spacer().frame(height : 20)

                        NavigationLink(destination: EmptyView()){
                            HStack{
                                Image("ic_privacy")
                                    .resizable()
                                    .frame(width: 30, height: 30, alignment: .leading)
                                    .foregroundColor(.btn_dark)
                                
                                Text("개인정보 처리 방침 읽기")
                                    .foregroundColor(.txt_color)
                                    .fontWeight(.semibold)
                                
                                Spacer()
                            }.padding(20)
                            .padding([.vertical], 10)
                            .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btn_color).shadow(radius: 2, x:0, y:2))
                        }
                        
                        Spacer().frame(height : 20)

                        NavigationLink(destination: EmptyView()){
                            HStack{
                                Image("ic_opensource")
                                    .resizable()
                                    .frame(width: 30, height: 30, alignment: .leading)
                                    .foregroundColor(.btn_dark)
                                
                                Text("오픈소스 라이센스 정보")
                                    .foregroundColor(.txt_color)
                                    .fontWeight(.semibold)
                                
                                Spacer()
                            }.padding(20)
                            .padding([.vertical], 10)
                            .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btn_color).shadow(radius: 2, x:0, y:2))
                        }
                        
                        Spacer().frame(height : 20)

                        NavigationLink(destination: EmptyView()){
                            HStack{
                                Image("ic_law")
                                    .resizable()
                                    .frame(width: 30, height: 30, alignment: .leading)
                                    .foregroundColor(.btn_dark)
                                
                                Text("법적 고지")
                                    .foregroundColor(.txt_color)
                                    .fontWeight(.semibold)
                                
                                Spacer()
                            }.padding(20)
                            .padding([.vertical], 10)
                            .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btn_color).shadow(radius: 2, x:0, y:2))
                        }
                        
                        Spacer().frame(height : 20)

                        NavigationLink(destination: EmptyView()){
                            HStack{
                                Image("ic_community")
                                    .resizable()
                                    .frame(width: 30, height: 30, alignment: .leading)
                                    .foregroundColor(.btn_dark)
                                
                                Text("커뮤니티 가이드라인")
                                    .foregroundColor(.txt_color)
                                    .fontWeight(.semibold)
                                
                                Spacer()
                            }.padding(20)
                            .padding([.vertical], 10)
                            .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btn_color).shadow(radius: 2, x:0, y:2))
                        }
                    }
                    
                    Group {
                        Spacer().frame(height : 20)
                        
                        NavigationLink(destination: EmptyView()){
                            HStack{
                                Image("ic_ad")
                                    .resizable()
                                    .frame(width: 30, height: 30, alignment: .leading)
                                    .foregroundColor(.btn_dark)
                                
                                Text("맞춤형 광고 안내")
                                    .foregroundColor(.txt_color)
                                    .fontWeight(.semibold)
                                
                                Spacer()
                            }.padding(20)
                            .padding([.vertical], 10)
                            .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btn_color).shadow(radius: 2, x:0, y:2))
                        }
                        
                        Spacer().frame(height : 20)
                        
                        NavigationLink(destination: EmptyView()){
                            HStack{
                                Image("ic_gpsLicense")
                                    .resizable()
                                    .frame(width: 30, height: 30, alignment: .leading)
                                    .foregroundColor(.btn_dark)
                                
                                Text("위치기반서비스 이용약관")
                                    .foregroundColor(.txt_color)
                                    .fontWeight(.semibold)
                                
                                Spacer()
                            }.padding(20)
                            .padding([.vertical], 10)
                            .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btn_color).shadow(radius: 2, x:0, y:2))
                        }
                    }
                    
                    Spacer().frame(height : 20)
                    
                    Group {
                        Text("© 2021. eje All Rights Reserved.")
                            .foregroundColor(.gray)
                            .font(.caption)
                        
                        Spacer().frame(height : 5)
                        
                        Text("이제이 | 대표 : 문소정 | 사업자등록번호 : 763-33-00865")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: true, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    }
                    
                    Spacer()
                }
                
            }.navigationBarTitle(Text("정보"), displayMode: .inline)
            
            .padding(20)
        }.background(Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
        .onAppear(perform: {
            helper.getVersion(){(data) in
                if let data = data{
                    latest = data["latest"] as? String ?? ""
                }
                
                else{
                    latest = "버전 정보를 불러올 수 없습니다."
                }
            }
        })
        
        .accentColor(.accent)

    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(helper: VersionManager())
    }
}
