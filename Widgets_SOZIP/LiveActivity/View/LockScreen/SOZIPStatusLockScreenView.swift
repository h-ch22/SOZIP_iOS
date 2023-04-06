//
//  SOZIPStatusLockScreenView.swift
//  SOZIP
//
//  Created by Changjin Ha on 2023/04/05.
//

import SwiftUI
import ActivityKit
import WidgetKit

@available(iOS 16.1, *)
struct SOZIPStatusLockScreenView : View{
    let context : ActivityViewContext<DynamicIsland_SOZIPAttributes>
    
    var body: some View{
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    HStack{
                        Image(uiImage: UIImage(named : "ic_liveActivities") ?? UIImage())
                            .resizable()
                            .frame(width : 40, height : 40)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        VStack{
                            HStack{
                                switch context.state.SOZIP_Status{
                                case "IN_PROGRESS":
                                    Text("소집이 진행 중이예요!")
                                        .font(.headline)
                                    
                                case "DONE":
                                    Text("소집이 완료되었어요!")
                                        .font(.headline)
                                    
                                case "PAY_DONE":
                                    Text("주문이 진행중이예요!")
                                        .font(.headline)
                                    
                                default:
                                    Text("소집 : SOZIP")
                                        .font(.headline)
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
                        }
                        
                        
                    }
                    
                    ZStack {
                        switch context.state.SOZIP_Status{
                        case "IN_PROGRESS":
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.gray)
                            
                        case "DONE":
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.gray)
                            
                            RoundedRectangle(cornerRadius: 15)
                                .trim(from : 0.25, to : 0.75)
                                .fill(Color.primary)
                            
                        case "PAY_DONE":
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.primary)
                            
                        default:
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.gray)
                        }
                        
                        
                        switch context.state.SOZIP_Status{
                        case "IN_PROGRESS":
                            HStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.primary)
                                    .frame(width: 50)
                                Image(systemName: "person.2.circle.fill")
                                    .foregroundColor(.white)
                                    .padding(.leading, -25)
                                Image(systemName: "arrow.forward")
                                    .foregroundColor(.white.opacity(0.5))
                                Image(systemName: "ellipsis")
                                    .foregroundColor(.white.opacity(0.5))
                                Text(timerInterval: context.state.estimatedSOZIPTime, countsDown: true)
                                    .bold()
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
                                    .multilineTextAlignment(.center)
                                Image(systemName: "ellipsis")
                                    .foregroundColor(.white.opacity(0.5))
                                Image(systemName: "arrow.forward")
                                    .foregroundColor(.white.opacity(0.5))
                                Image(systemName: "fork.knife.circle.fill")
                                    .foregroundColor(.primary)
                                    .background(.white)
                                    .clipShape(Circle())
                                    .padding(.trailing, 25)
                            }
                            
                        case "DONE":
                            HStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.primary)
                                    .frame(width: 50)
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.white)
                                    .padding(.leading, -25)
                                Image(systemName: "arrow.forward")
                                    .foregroundColor(.white)
                                Image(systemName: "ellipsis")
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Image(systemName: "ellipsis")
                                    .foregroundColor(.white.opacity(0.5))
                                Image(systemName: "arrow.forward")
                                    .foregroundColor(.white.opacity(0.5))
                                Image(systemName: "fork.knife.circle.fill")
                                    .foregroundColor(.primary)
                                    .background(.white)
                                    .clipShape(Circle())
                                    .padding(.trailing, 25)
                            }
                            
                        case "PAY_DONE":
                            HStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.primary)
                                    .frame(width: 50)
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.white)
                                    .padding(.leading, -25)
                                Image(systemName: "arrow.forward")
                                    .foregroundColor(.white)
                                Image(systemName: "ellipsis")
                                    .foregroundColor(.white)
                                Spacer()
                                
                                Image(systemName: "ellipsis")
                                    .foregroundColor(.white)
                                Image(systemName: "arrow.forward")
                                    .foregroundColor(.white)
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.white)
                                    .padding(.trailing, 25)
                            }
                            
                        default:
                            EmptyView()
                        }
                    }
                    
                    Spacer()
                    
                }

            }.padding(5)
            Text("\(context.attributes.SOZIPName)")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal, 5)
        
        }.padding(15)
        .activitySystemActionForegroundColor(Color.black)
    }
}

