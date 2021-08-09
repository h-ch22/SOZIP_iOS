//
//  editProfileView.swift
//  editProfileView
//
//  Created by 하창진 on 2021/08/06.
//

import SwiftUI

struct editProfileView: View {
    var body: some View {
        ZStack {
            Color.backgroundColor.edgesIgnoringSafeArea(.all)
            
            ScrollView{
                VStack {
                    HStack{
                        
                    }
                }.padding(20)
                    .navigationBarTitle(Text("프로필 변경"), displayMode: .inline)
            }
        }
        
    }
}

struct editProfileView_Previews: PreviewProvider {
    static var previews: some View {
        editProfileView()
    }
}
