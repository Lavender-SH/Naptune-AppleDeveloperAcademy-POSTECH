//
//  NapApp.swift
//  Nap
//
//  Created by YunhakLee on 7/24/24.
//

import SwiftUI
import AuthenticationServices


@main
struct NapApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("firstLaunch") var firstLaunch: Bool = true
    @AppStorage("isOnboarding") var isLogined: Bool = false
    @StateObject private var timerData = TimerData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(timerData)
                .onAppear {
                    let appleIDProvider = ASAuthorizationAppleIDProvider()
                     appleIDProvider.getCredentialState(forUserID: "/*user의 고유 ID값(xxxxx.xxxxxxxxxx.xxxx)*/") { (credentialState, error) in
                         switch credentialState {
                             case .authorized:
                                print("authorized")
                                // The Apple ID credential is valid.
                                DispatchQueue.main.async {
                                  //authorized된 상태이므로 바로 로그인 완료 화면으로 이동
                                    isLogined = false
                                }
                             case .revoked:
                                print("revoked")
                             case .notFound:
                                // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
                                print("notFound")
                                    
                             default:
                                 break
                         }
                     }
                }
        }
    }
}
