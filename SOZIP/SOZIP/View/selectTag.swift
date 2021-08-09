//
//  TagView.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/30.
//

import SwiftUI

struct selectTag: View {
    @ObservedObject var helper : TagManager
    @Environment(\.presentationMode) var presentationMode
    @State private var selected = "All"

    var body: some View {
        NavigationView{
            ScrollView{
                ZStack{
                    Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    
                    VStack{
                        Spacer().frame(height : 20)
                        
                        ScrollView(.horizontal){
                            LazyHStack{
                                ForEach(helper.categoryList, id: \.self){category in
                                    Button(action: {
                                        self.selected = category.category
                                    }){
                                        Text(category.category_KR)
                                            .foregroundColor(self.selected == category.category ? .white : .accent)
                                    }.padding(10)
                                    .padding([.horizontal], 10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundColor(self.selected == category.category ? .accent : .clear)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius : 10)
                                            .stroke(lineWidth : 2)
                                            .foregroundColor(.accent)
                                            .isHidden(self.selected == category.category ? true : false)
                                    )
                                }
                            }
                        }.padding()
                        .padding([.vertical], 10)
                        
                        Spacer().frame(height : 20)

                        Text("원하는 태그를 선택해보세요!")
                            .fontWeight(.semibold)
                        
                        
                    }
                }
            }.navigationBarTitle(Text("태그 설정"), displayMode: .automatic)
            .navigationBarItems(trailing: Button("닫기"){
                self.presentationMode.wrappedValue.dismiss()
            })
            
            .background(Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
            
            .onAppear(perform: {
                helper.getCategory()
            })
            
            .accentColor(.accent)
        }
    }
}

struct selectTag_Previews: PreviewProvider {
    static var previews: some View {
        selectTag(helper : TagManager())
    }
}
