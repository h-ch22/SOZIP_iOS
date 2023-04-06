//
//  Widgets_SOZIPLiveActivity.swift
//  Widgets_SOZIP
//
//  Created by Changjin Ha on 2023/04/05.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct DynamicIsland_SOZIPStatus_LiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DynamicIsland_SOZIPAttributes.self) { context in
            SOZIPStatusLockScreenView(context : context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.bottom) {
                    SOZIPStatusDynamicIsland_Bottom(context : context)
                }
                
                DynamicIslandExpandedRegion(.center){
                    SOZIPStatusDynamicIsland_Center(context : context)
                }
                
                DynamicIslandExpandedRegion(.leading) {
                    SOZIPStatusDynamicIsland_Leading()
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    SOZIPStatusDynamicIsland_Trailing(context : context)
                }
            
            } compactLeading: {
                Image(uiImage: UIImage(named : "ic_liveActivities") ?? UIImage())
                    .resizable()
                    .frame(width : 25, height : 25)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            } compactTrailing: {
                switch context.state.SOZIP_Status{
                case "IN_PROGRESS":
                    Text(timerInterval: context.state.estimatedSOZIPTime, countsDown: true)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .frame(width: 40)
                        .font(.caption2)
                    
                case "DONE":
                    Text("소집 완료")
                        .foregroundColor(.primary)
                    
                case "PAY_DONE":
                    Text("주문 완료")
                        .foregroundColor(.primary)
                    
                default:
                    Text("")
                }
            } minimal: {
                Image(uiImage: UIImage(named : "ic_liveActivities") ?? UIImage())
                    .resizable()
                    .frame(width : 25, height : 25)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            .keylineTint(.primary)
        }
    }
}

@available(iOSApplicationExtension 16.2, *)
struct Widgets_SOZIPLiveActivity_Previews: PreviewProvider {
    static let attributes = DynamicIsland_SOZIPAttributes(totalCount: 5, SOZIPName: "피자 드실 분!")
    static let contentState = DynamicIsland_SOZIPAttributes.ContentState(SOZIP_Status: "IN_PROGRESS", estimatedSOZIPTime: Date()...Date().addingTimeInterval(50000*60), SOZIP_Count : 1)

    static var previews: some View {
        if #available(iOS 16.2, *){
            attributes
                .previewContext(contentState, viewKind: .dynamicIsland(.compact))
                .previewDisplayName("Island Compact")
            attributes
                .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
                .previewDisplayName("Island Expanded")
            attributes
                .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
                .previewDisplayName("Minimal")
            attributes
                .previewContext(contentState, viewKind: .content)
                .previewDisplayName("Notification")
        }

    }
}
