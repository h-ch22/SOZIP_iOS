//
//  DynamicIsland_SOZIPAttributes.swift
//  SOZIP
//
//  Created by Changjin Ha on 2023/04/05.
//

import SwiftUI
import ActivityKit

struct DynamicIsland_SOZIPAttributes: ActivityAttributes {
    public typealias DynamicIslandStatus = ContentState
    
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var SOZIP_Status : String
        var estimatedSOZIPTime : ClosedRange<Date>
        var SOZIP_Count : Int
    }

    // Fixed non-changing properties about your activity go here!
    var totalCount : Int
    var SOZIPName : String = ""
}
