//
//  LiveActivityHelper.swift
//  SOZIP
//
//  Created by Changjin Ha on 2023/04/05.
//

import Foundation
import ActivityKit

class LiveActivityHelper{
    var activityID = ""
    
    func startActivity(totalCount : Int,
                       SOZIPName : String,
                       end : Date){
        if #available(iOS 16.2, *){
            if ActivityAuthorizationInfo().areActivitiesEnabled{
                let dateFormatter = DateFormatter()
                let calendar = Calendar.current

                dateFormatter.dateFormat = "yyyy. MM. dd. kk:mm:ss"

                let endDate_tmp = dateFormatter.string(from: end)
                let startDate_tmp = dateFormatter.string(from: Date())

                let endDate = dateFormatter.date(from: endDate_tmp)
                let startDate = dateFormatter.date(from: startDate_tmp)

                let difference = (endDate ?? Date()).timeIntervalSinceReferenceDate -
                (startDate ?? Date()).timeIntervalSinceReferenceDate

                let attributes = DynamicIsland_SOZIPAttributes(totalCount: totalCount, SOZIPName: SOZIPName + " 시키실 분!")

                let contentState = DynamicIsland_SOZIPAttributes.ContentState(SOZIP_Status: "IN_PROGRESS", estimatedSOZIPTime: Date()...Date().addingTimeInterval(difference), SOZIP_Count: 1)

                do{
                    let activity = try Activity<DynamicIsland_SOZIPAttributes>.request(
                        attributes : attributes,
                        contentState : contentState)
                    
                    activityID = activity.id
                    
                } catch(let error){
                    print(error)
                }
            }
        }
    }
}
