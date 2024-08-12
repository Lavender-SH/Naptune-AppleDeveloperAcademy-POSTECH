//
//  ContentView.swift
//  Nap
//
//  Created by YunhakLee on 7/24/24.
//

import SwiftUI

struct ContentView: View {
    @State var isLoading: Bool = true
    @AppStorage("firstLaunch") var firstLaunch: Bool = false
    @AppStorage("friendAdded") var friendAdded: Bool = false
    //@AppStorage("isOnboarding") var isLogined: Bool = false
    
    var body: some View {
        if isLoading {
            Splash()
                .onAppear {
                    //firstLaunch = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                        withAnimation {
                            isLoading = false
                        }
                    }
                }
        } else {
            if firstLaunch {
                Onboarding()
            } else {
                Main
            }
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
                    Home()
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
