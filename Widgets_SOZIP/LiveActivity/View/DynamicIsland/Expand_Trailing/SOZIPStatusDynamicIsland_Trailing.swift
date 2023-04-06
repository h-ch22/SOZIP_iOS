//
//  SOZIPStatusDynamicIsland_Trailing.swift
//  SOZIP
//
//  Created by Changjin Ha on 2023/04/05.
//

import SwiftUI
import ActivityKit
import WidgetKit

@available(iOS 16.1, *)
struct SOZIPStatusDynamicIsland_Trailing: View {
    let context : ActivityViewContext<DynamicIsland_SOZIPAttributes>

    var body: some View {
        HStack{
            Image(systemName: "person.2.fill")
                .font(.headline)
            
            Text("\(context.state.SOZIP_Count)/\(context.attributes.totalCount)")
                .font(.subheadline)
        }
    }
}
