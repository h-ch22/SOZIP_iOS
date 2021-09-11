//
//  URLTutorialContentsView.swift
//  SOZIP
//
//  Created by 하창진 on 2021/09/05.
//

import SwiftUI

struct URLTutorialContentsView: View {
    @State private var isAnimating = false
    let data : URLTutorialContentsData
    
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
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                
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
