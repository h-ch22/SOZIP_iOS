//
//  FullscreenImageView.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/27.
//

import SwiftUI
import SDWebImageSwiftUI

struct FullscreenImageView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var selectedIndex : Int
    
    @State private var offset : CGSize = .zero
    @State var lastScaleValue: CGFloat = 1.0

    let imgURL : [String?]

    var body: some View {
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack{
                ZStack(alignment : .topLeading){
                    ZStack(alignment : .center){
                        TabView(selection : $selectedIndex){
                            ForEach(imgURL.indices, id : \.self){index in
                                WebImage(url: URL(string : imgURL[index]!))
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .tag(index)
                            }
                        }.tabViewStyle(PageTabViewStyle())
                        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                        
                        HStack{
                            Button(action : {
                                selectedIndex -= 1
                            }){
                                Image(systemName: "chevron.left.circle")
                                    .resizable()
                                    .frame(width : 30, height : 30)
                            }.isHidden(self.selectedIndex == 0)
                            
                            Spacer()
                            
                            Button(action : {
                                selectedIndex += 1
                            }){
                                Image(systemName: "chevron.right.circle")
                                    .resizable()
                                    .frame(width : 30, height : 30)
                                    .padding(20)
                                
                            }.isHidden(self.selectedIndex == self.imgURL.count - 1)
                        }.padding([.horizontal], 20)
                    }
                    
                    Button(action : {self.presentationMode.wrappedValue.dismiss()}){
                        VStack{
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                        }.padding(10)
                        .padding([.horizontal], 10)
                        .background(RoundedRectangle(cornerRadius: 10).shadow(radius: 5).foregroundColor(.gray).opacity(0.5))

                    }.padding(20)
                    
                }

            }
            
        }
    }
}
