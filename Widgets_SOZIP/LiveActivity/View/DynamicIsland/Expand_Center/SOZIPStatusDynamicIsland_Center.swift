//
//  SOZIPStatusDynamicIsland_Center.swift
//  SOZIP
//
//  Created by Changjin Ha on 2023/04/05.
//

import SwiftUI
import ActivityKit
import WidgetKit

@available(iOS 16.1, *)
struct SOZIPStatusDynamicIsland_Center: View {
    let context : ActivityViewContext<DynamicIsland_SOZIPAttributes>

    var body: some View {
        VStack{
            HStack{
                switch context.state.SOZIP_Status{
                case "IN_PROGRESS":
                    Text("소집이 진행 중이예요!")
                        .fontWeight(.semibold)
                    
                case "DONE":
                    Text("소집이 완료되었어요!")
                        .fontWeight(.semibold)
                    
                case "PAY_DONE":
                    Text("주문이 진행중이예요!")
                        .fontWeight(.semibold)
                    
                default:
                    Text("")
                }
                
                Spacer()
            }
            
            HStack{
                switch context.state.SOZIP_Status{
                case "IN_PROGRESS":
                    Text("총 \(context.attributes.totalCount)명 중 \(context.state.SOZIP_Count)명이 모였어요.")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                case "DONE":
                    Text("메뉴 선택 및 정산을 완료해주세요.")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                case "PAY_DONE":
                    Text("잠시 기다리면 음식이 도착합니다.")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                default:
                    Text("")
                }
                
                Spacer()
            }
        }    }
}
