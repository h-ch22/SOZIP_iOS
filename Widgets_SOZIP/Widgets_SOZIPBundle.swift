//
//  Widgets_SOZIPBundle.swift
//  Widgets_SOZIP
//
//  Created by Changjin Ha on 2023/04/05.
//

import WidgetKit
import SwiftUI

@main
struct Widgets_SOZIPBundle: WidgetBundle {
    var body: some Widget {
        Widgets_SOZIP()
        
        if #available(iOS 16.2, *){
            DynamicIsland_SOZIPStatus_LiveActivity()
        }
    }
}

extension Color{
    static let primary = Color("AccentColor")
}
