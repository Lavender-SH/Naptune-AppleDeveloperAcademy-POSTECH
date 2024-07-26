//
//  ContentView.swift
//  Nap
//
//  Created by YunhakLee on 7/24/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader {proxy in
            ScrollView {
                VStack(spacing: 0) {
                    BackgroundImage(image: Image(.timerBackground))
                        .frame(width: proxy.size.width, height: proxy.size.height)
                    Feed()
                        .frame(width: proxy.size.width, height: proxy.size.height)
                }
            }
            .scrollTargetBehavior(.paging)
        }
        .ignoresSafeArea()
        .background(BackgroundImage(image: Image(.feedBackground)))
    }
}

#Preview {
    ContentView()
}
