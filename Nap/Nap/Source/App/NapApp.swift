//
//  NapApp.swift
//  Nap
//
//  Created by YunhakLee on 7/24/24.
//

import SwiftUI
import Firebase
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        registerBackgroundTask()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        endBackgroundTask()
    }
    
    func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask {
            self.endBackgroundTask()
        }
        assert(backgroundTask != .invalid)
    }
    
    func endBackgroundTask() {
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = .invalid
    }
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { granted, error in
                if let error = error {
                    print("Error requesting authorization for notifications: \(error.localizedDescription)")
                }
            }
        )
        
        application.registerForRemoteNotifications()
        
        return true
    }
}


@main
struct NapApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
