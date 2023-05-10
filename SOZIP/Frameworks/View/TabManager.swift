//
//  TabManager.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/28.
//

import SwiftUI

struct TabManager: View {
    @State var selectedIndex = 0
    @State private var showModal = false
    @ObservedObject var chatHelper : ChatHelper
    @ObservedObject var helper : SOZIPHelper

    let icon = ["house.fill", "map.fill", "plus", "message.fill", "ellipsis.circle.fill"]
    
    var body: some View {
        NavigationView{
            VStack{
                ZStack{
                    switch selectedIndex{
                    case 0:
                        SOZIPListView(helper: SOZIPHelper(), data : helper.SOZIPList, categoryList:helper.categoryList).environmentObject(UserManagement())
                        
                    case 1:
                        navigateToSOZIPMap(data : helper.SOZIPList)
                        
                    case 3:
                        ChatListView(helper : ChatHelper(), SOZIPHelper: SOZIPHelper(), data : chatHelper.ChatList, SOZIPData : helper.SOZIPList)
                        
                    case 4:
                        MoreView().environmentObject(UserManagement())
                        
                    default:
                        SOZIPListView(helper: SOZIPHelper(), data : helper.SOZIPList, categoryList:helper.categoryList).environmentObject(UserManagement())

                    }
                }
                
                Spacer()
                
                Divider()
                
                HStack{
                    ForEach(0..<5, id:\.self){number in
                        Spacer()
                        
                        Button(action: {
                            if number == 2{
                                self.showModal = true
                            }
                            
                            else{
                                selectedIndex = number
                            }
                        }){
                            if number == 2{
                                Image(systemName: icon[number])
                                    .font(.system(
                                        size: 25,
                                        weight: .regular,
                                        design: .default
                                    ))
                                    .foregroundColor(.white)
                                    .frame(width : 60, height : 60)
                                    .background(Color.accent)
                                    .cornerRadius(30)
                                    .shadow(radius: 3)
                            }
                            
                            else{
                                Image(systemName: icon[number])
                                    .font(.system(
                                        size: 25,
                                        weight: .regular,
                                        design: .default
                                    ))
                                    .foregroundColor(selectedIndex == number ? .accent : .gray)
                            }
                            
                        }
                        
                        Spacer()
                    }
                }
            }
            
            .sheet(isPresented: $showModal, content: {
                addSozipView(isShowing : self.$showModal, receiver : SOZIPLocationReceiver()).environmentObject(UserManagement())
            })
            
            .onAppear(perform: {
                helper.getSOZIP(){result in
                    guard let result = result else{return}
                }
                
                chatHelper.getChatList(){result in
                    guard let result = result else{return}
                }
            })
            
            .background(Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
            
            .accentColor(.accent)
        }
        .navigationBarHidden(true)
        .navigationViewStyle(.stack)

        
    }
}
