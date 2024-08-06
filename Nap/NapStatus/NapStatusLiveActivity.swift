//
//  NapStatusLiveActivity.swift
//  NapStatus
//
//  Created by 이승현 on 8/6/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct NapStatusAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var remainingTime: Int = 0
    }
}

struct NapStatusLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: NapStatusAttributes.self) { context in
            ZStack {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color("상단네이비"), Color("하단네이비")]),
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                    .opacity(0.5)
                    .frame(maxWidth: .infinity, maxHeight: 200)
                
                VStack(alignment: .center) {
                    Text("남은 낮잠 시간")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                    Spacer()
                    Text("\(context.state.remainingTime / 3600)시간 \((context.state.remainingTime % 3600) / 60)분 \((context.state.remainingTime % 3600) % 60)초")
                        .font(.system(size: 44, weight: .semibold))
                        .foregroundColor(.white)
                }
                .padding(20)
                
            }
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    ZStack{
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Nap")
                                    .font(.system(size: 22).bold())
                                    .foregroundColor(.white)
                                Image(systemName: "bolt.fill")
                            }
                        }
                    }
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    Text("\(context.state.remainingTime / 3600)시간 \((context.state.remainingTime % 3600) / 60)분 \((context.state.remainingTime % 3600) % 60)초")
                        .font(.system(size: 16).bold())
                        .foregroundColor(.white)
                }
                
                
            } compactLeading: {
                Image(systemName: "bolt.fill")
            } compactTrailing: {
                
            } minimal: {
                Image(systemName: "bolt.fill")
            }
        }
    }
}

