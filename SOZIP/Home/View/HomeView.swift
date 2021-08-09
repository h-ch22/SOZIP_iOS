//
//  HomeView.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/20.
//

import SwiftUI
import AdSupport

struct HomeView: View {
    @EnvironmentObject var helper : UserManagement
    @State private var greet : String = ""
    @State private var showATTPermissionView = false
    @State private var showBETAModal = false
    
    func calculate_Time(){
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        
        let current_string = formatter.string(from: Date())
        let current_hour = Int(current_string) ?? 0
        
        if current_hour >= 6 && current_hour <= 11{
            greet = "좋은 아침이예요,"
        }
        
        else if current_hour >= 12 && current_hour <= 17{
            greet = "좋은 오후예요,"
        }
        
        else if current_hour >= 18{
            greet = "좋은 밤이예요,"
        }
        
        else if current_hour >= 0 && current_hour <= 5{
            greet = "좋은 밤이예요,"
        }
    }
    
    var body: some View {
        NavigationView{
            VStack {
                HStack{
                    Text("소집 : SOZIP")
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    NavigationLink(destination : NotificationCenter()){
                        Image(systemName: "bell.fill")
                            .resizable()
                            .frame(width : 20, height : 20)
                            .foregroundColor(.txt_color)
                    }
                }
                
                Spacer().frame(height : 15)
                
                HStack {
                    Text("\(greet)\n\(helper.name)님!")
                    
                    Spacer()
                }
                
                Spacer()
            }
            
            
            .padding([.horizontal], 20)
            .navigationBarHidden(true)
            .onAppear(perform: {
                calculate_Time()
                
                if !UserDefaults.standard.bool(forKey: "launchedBefore"){
                    self.showATTPermissionView = true
                    self.showBETAModal = true
                }
            })
            
            .fullScreenCover(isPresented: $showATTPermissionView){
                requestATTPermission()
            }
            
            .sheet(isPresented: $showBETAModal, content: {
                IntroduceFeedbackHub()
            })
            
            .background(Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(UserManagement())
    }
}
