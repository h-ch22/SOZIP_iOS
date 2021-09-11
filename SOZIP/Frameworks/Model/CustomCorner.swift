//
//  CustomCorner.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/25.
//

import SwiftUI

struct CustomCorner: Shape {
    var corners : UIRectCorner
    var radius : CGFloat
    
    func path(in rect : CGRect) -> Path{
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    
        return Path(path.cgPath)
    }
}
