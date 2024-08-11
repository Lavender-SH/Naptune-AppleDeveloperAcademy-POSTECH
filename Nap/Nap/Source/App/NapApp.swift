//
//  NapApp.swift
//  Nap
//
//  Created by YunhakLee on 7/24/24.
//

import SwiftUI


@main
struct NapApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var timerData = TimerData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(timerData)
        }
    }
}
