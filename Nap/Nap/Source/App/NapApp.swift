//
//  NapApp.swift
//  Nap
//
//  Created by YunhakLee on 7/24/24.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct NapApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var loginComplete = UserDefaults.standard.bool(forKey: "loginComplete")


  var body: some Scene {
    WindowGroup {
      NavigationView {
        Onboarding(loginComplete: $loginComplete)
      }
    }
  }
}
