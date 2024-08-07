//
//  AppDelegate.swift
//  Nap
//
//  Created by Jeho Ahn on 8/7/24.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseMessaging
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Error requesting notification authorization: \(error)")
            }
        }
        
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { granted, error in
                if let error = error {
                    print("Error requesting authorization for notifications: \(error.localizedDescription)")
                }
            }
        )
        
        // Firebase Authentication 설정
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously { (authResult, error) in
                if let error = error {
                    print("Firebase anonymous authentication failed: \(error.localizedDescription)")
                } else {
                    print("Firebase anonymous authentication succeeded")
                }
            }
        }
        
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcmToken = fcmToken {
            print("FCM Token: \(fcmToken)")
        }
    }
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
}

