//
//  OnBoardingView.swift
//  SOZIP
//
//  Created by 하창진 on 2021/09/04.
//

import SwiftUI

struct OnBoardingView: View {
    var data : TutorialContentsData
    
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing : 20) {
            ZStack{
                Image(data.objectImage)
                    .resizable()
                    .scaledToFit()
                    .offset(x: 0, y: 150)
                    .scaleEffect(isAnimating ? 1 : 0.9)
            }
            
            Spacer()
            Spacer()
            
            HStack {
                Text(data.primaryText)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.txt_color)
                
                Spacer()
            }
            
            HStack {
                Text(data.secondaryText)
                    .font(.headline)
                    .frame(maxWidth : 250)
                    .foregroundColor(.gray)
                
                Spacer()
            }
            
            Spacer()

        }.onAppear(perform: {
            isAnimating = false
            withAnimation(.easeOut(duration: 0.5)){
                self.isAnimating = true
            }
        })
        
    }
}

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView(data : TutorialContentsData.contents_idCard.first!)
    }
}
