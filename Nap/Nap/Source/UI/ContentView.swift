//
//  ContentView.swift
//  Nap
//
//  Created by YunhakLee on 7/24/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Main
    }
}

extension ContentView {
    
    // MARK: View
    
    var Main: some View {
        NavigationStack{
            GeometryReader {proxy in
                ScrollView {
                    VStack(spacing: 0) {
                        Home()
                            .frame(width: proxy.size.width, height: proxy.size.height)
                        Feed()
                            .frame(width: proxy.size.width, height: proxy.size.height)
                    }
                }
                .scrollTargetBehavior(.paging)
                .scrollIndicators(.never)
            }
            .ignoresSafeArea()
            .navigationTitle("")
        }
    }
}

#Preview {
    ContentView()
}
