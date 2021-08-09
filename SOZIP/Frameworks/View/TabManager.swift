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
    let icon = ["house.fill", "safari.fill", "plus", "message.fill", "ellipsis.circle.fill"]
    
    var body: some View {        
        VStack{
            ZStack{
                switch selectedIndex{
                case 0:
                    HomeView().environmentObject(UserManagement())
                    
                case 1:
                    SOZIPListView(helper: SOZIPHelper())
                    
                case 3:
                    ChatView(helper : ChatHelper())
                    
                case 4:
                    MoreView().environmentObject(UserManagement())
                    
                default:
                    HomeView().environmentObject(UserManagement())
                    
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
            addSozipView(receiver : SOZIPLocationReceiver())
        })
        
        .background(Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
        
        .accentColor(.accent)
        
        .navigationBarHidden(true)
        
    }
}

struct TabManager_Previews: PreviewProvider {
    static var previews: some View {
        TabManager()
    }
}
