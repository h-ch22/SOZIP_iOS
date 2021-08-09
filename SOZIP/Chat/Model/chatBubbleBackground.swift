//
//  chatBubbleBackground.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/09.
//

import SwiftUI

struct chatBubbleBackground : Shape{
    var myMsg : Bool
    
    func path(in rect : CGRect) -> Path{
        let path = UIBezierPath(roundedRect : rect, byRoundingCorners: [.topLeft, .topRight, myMsg ? .bottomLeft : .bottomRight], cornerRadii: CGSize(width : 15, height : 15))
        
        return Path(path.cgPath)
    }
}
