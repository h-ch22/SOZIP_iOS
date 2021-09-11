//
//  BlurView.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/25.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
    var style : UIBlurEffect.Style
    typealias UIViewType = UIVisualEffectView
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect : UIBlurEffect(style: style))
        
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
}
