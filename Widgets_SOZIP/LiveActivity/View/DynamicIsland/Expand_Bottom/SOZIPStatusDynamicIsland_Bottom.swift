//
//  SOZIPStatusDynamicIsland_Bottom.swift
//  SOZIP
//
//  Created by Changjin Ha on 2023/04/05.
//

import SwiftUI
import WidgetKit
import ActivityKit

@available(iOS 16.1, *)
struct SOZIPStatusDynamicIsland_Bottom: View {
    let context : ActivityViewContext<DynamicIsland_SOZIPAttributes>

    var body: some View {
        VStack(alignment : .leading){
            HStack{
                VStack(alignment : .leading){
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
                    
                    VStack{
                        Text("\(context.attributes.SOZIPName)")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(5)
                        
                    }
                    

                }.padding(5)
            }
        }
    }
}
