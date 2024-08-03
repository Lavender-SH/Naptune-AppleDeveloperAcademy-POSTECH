//
//  ContentView.swift
//  Nap
//
//  Created by YunhakLee on 7/24/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var isOnboarding: Bool = false
    //@State var showHome: Bool = true
    
    var body: some View {
        if isOnboarding {
            Onboarding(isOnboarding: $isOnboarding)
        } else {
            Main
        }
    }
}

extension ContentView {
    
    // MARK: View
    
    var Main: some View {
        NavigationStack {
            ScrollView(.vertical) {
                //ScrollViewReader { reader in
                VStack(spacing: 0) {
                    NagiHome()
                        .frame(width: UIScreen.size.width,
                               height: UIScreen.size.height)
                        .id(1)
                    Feed()
                        .frame(width: UIScreen.size.width,
                               height: UIScreen.size.height)
                        .id(2)
                        //.border(Color.blue)
                    //                        .onChange(of: showHome) { _, _ in
                    //                            withAnimation(.bouncy) {
                    //                                showHome ? reader.scrollTo(1)
                    //                                         : reader.scrollTo(2)
                    //                            }
                    //                        }
                    // }
                }
            }
            .ignoresSafeArea()
            .scrollTargetBehavior(.paging)
            .scrollIndicators(.never)
            .navigationTitle("")
        }
    }
}

#Preview {
    ContentView()
}
