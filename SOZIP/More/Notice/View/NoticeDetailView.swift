//
//  NoticeDetailView.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/27.
//

import SwiftUI
import SDWebImageSwiftUI
import SwiftUIPager

struct NoticeDetailView: View {
    let data : NoticeDataModel
    @ObservedObject var helper : NoticeHelper
    
    @State private var page : Page = Page.first()
    @State private var showFullScreenImgView = false
    @State private var selectedIndex = 0
    
    func imgView(_ page : Int) -> some View{
        WebImage(url: URL(string : helper.imageURL[page]!))
            .resizable()
            .frame(width: 250, height: 250)
            .scaledToFit()
            .onTapGesture(perform: {
                self.selectedIndex = page
                self.showFullScreenImgView = true
            })
    }
    
    var body: some View {
        VStack{
            Spacer().frame(height : 15)
            
            HStack{
                Text(data.noticeTitle)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            
            Divider()
            
            HStack{
                Text(data.timeStamp)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
            }
            
            ScrollView{
                
                VStack {
                    Spacer().frame(height : 5)
                    
                    if data.imageId != nil{
                        VStack{
                            Pager(page : page,
                                  data : helper.imageURL.indices,
                                  id : \.self){
                                self.imgView($0)
                            }
                                .interactive(scale : 0.8)
                                .interactive(opacity: 0.5)
                                .itemSpacing(10)
                                .pagingPriority(.simultaneous)
                                .itemAspectRatio(1.3, alignment: .start)
                                .padding(20)
                                .sensitivity(.high)
                                .preferredItemSize(CGSize(width : 250, height : 250))
                            
                            Spacer().frame(height : 15)
                        }.frame(height : 265)
                    }
                                        
                    Text(data.contents.replacingOccurrences(of: "\\n", with: "\n"))
                        .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                        .lineSpacing(5)
                    
                    Spacer().frame(height : 15)
                    
                    if data.url != nil{
                        Link(destination : URL(string: data.url!)!){
                            HStack{
                                Text("URL 연결하기")
                                    .foregroundColor(.white)
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                            }.padding(20)
                            .padding([.horizontal], 100)
                            .background(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).shadow(radius: 5).foregroundColor(.accent))
                        }
                    }
                }
            }
        }
        .padding([.horizontal], 20)
        .navigationBarTitle(data.noticeTitle, displayMode: .inline)
        .background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
        .onAppear(perform: {
            if data.imageId != nil{
                helper.getImageURL(imageId: data.imageId, imageIndex: data.imageIndex)
            }
        })
        
        .fullScreenCover(isPresented: $showFullScreenImgView, content: {
            FullscreenImageView(selectedIndex: $selectedIndex, imgURL: helper.imageURL)
        })
    }
}
