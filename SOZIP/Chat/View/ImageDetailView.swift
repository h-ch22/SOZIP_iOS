//
//  ImageDetailView.swift
//  ImageDetailView
//
//  Created by 하창진 on 2021/08/07.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import LinkPresentation

struct ImageDetailView : View{
    @Binding var imgURL : [String?]
    @Binding var docRef : String
    @State private var currentPage = 0
    @State private var showActionSheet = false
    
    let helper : ChatHelper

    @Environment(\.presentationMode) var presentationMode
    
    private func imageActionSheet() -> ActionSheet{
        let buttons = [
            ActionSheet.Button.default(Text("전체 이미지 저장하기")){
                helper.downloadMultipleImage(url: imgURL, docRef: docRef)
            },
            
            ActionSheet.Button.default(Text("이 이미지만 저장하기")){
                helper.downloadSingleImage(url: URL(string: imgURL[currentPage]!), docRef: docRef, index: currentPage)
            },
            
            ActionSheet.Button.cancel(Text("취소"))
        ]
        
        let actionSheet = ActionSheet(title : Text("이미지 저장 방식 선택"),
                                      message: Text("원하시는 옵션을 선택하세요!"),
                                      buttons: buttons)
        
        return actionSheet
    }
    
    var body : some View{
        NavigationView{
            ZStack {
                TabView(selection : $currentPage){
                    ForEach(imgURL.indices){item in
                        WebImage(url : URL(string: imgURL[item]!))
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width)
                            .tag(item)
                            .pinchToZoom()
                    }
                    
                }.tabViewStyle(PageTabViewStyle())
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                
                
                if imgURL.count > 1{
                    HStack{
                        Button(action : {
                            if currentPage != 0{
                                currentPage -= 1
                            }
                        }){
                            Image(systemName: "chevron.left.circle")
                                .resizable()
                                .frame(width : 40, height : 40)
                                .foregroundColor(currentPage == 0 ? .gray : .accent)
                                .shadow(radius: 5)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            if currentPage != imgURL.count - 1{
                                currentPage += 1
                            }
                        }){
                            Image(systemName: "chevron.right.circle")
                                .resizable()
                                .frame(width : 40, height : 40)
                                .foregroundColor(currentPage == imgURL.count - 1 ? .gray : .accent)
                                .shadow(radius: 5)
                        }
                    }.padding([.horizontal], 20)
                }
                
                
            }
            .navigationBarItems(leading : Button(action : {
                if imgURL.count > 1{
                    showActionSheet = true
                }
                
                else{
                    helper.downloadSingleImage(url: URL(string: imgURL[currentPage]!), docRef: docRef, index: currentPage)
                    
                }
            }){
                Image(systemName: "icloud.and.arrow.down.fill")
            })
            
            .actionSheet(isPresented: $showActionSheet){
                imageActionSheet()
            }
            
            .toolbar{
                
                ToolbarItemGroup(placement : .navigationBarTrailing){
                    
                    Button("닫기"){
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            
            .navigationViewStyle(StackNavigationViewStyle())
            
            
            
            
        }.onAppear(perform: {
            print("launched image view.")
        })
        
    }
}
