//
//  URLTutorialView.swift
//  SOZIP
//
//  Created by 하창진 on 2021/09/05.
//

import SwiftUI

struct URLTutorialView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var current = 0
    
    var body: some View {
        NavigationView{
            ZStack {
                Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
                VStack {
                    TabView(selection : $current){
                        ForEach(URLTutorialContentsData.contents){data in
                            URLTutorialContentsView(data : data)
                                .tag(data.id)
                        }
                    }.tabViewStyle(PageTabViewStyle())
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .interactive))
                    Spacer()
                    
                    HStack{
                        Spacer()
                        
                        Button(action : {
                            if current < 2{
                                current += 1
                            }
                            
                            else{
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }){
                            if current < 2{
                                Image(systemName: "arrow.right")
                                    .resizable()
                                    .frame(width : 20, height : 20)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Circle().foregroundColor(.accent))
                            }
                            
                            else{
                                Image(systemName: "xmark")
                                    .resizable()
                                    .frame(width : 20, height : 20)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Circle().foregroundColor(.red))
                            }
                        }
                    }
                }
            }.padding(20)
            .background(Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
            .navigationBarTitle(Text("배달앱 URL 불여넣기"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action : {
                self.presentationMode.wrappedValue.dismiss()
            }){
                Text("닫기")
            })
            
        }
        
    }
}

struct URLTutorialView_Previews: PreviewProvider {
    static var previews: some View {
        URLTutorialView()
            .preferredColorScheme(.dark)
    }
}
