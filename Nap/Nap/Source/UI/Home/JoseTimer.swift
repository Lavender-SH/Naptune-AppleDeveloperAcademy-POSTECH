//
//  Home.swift
//  Nap
//
//  Created by YunhakLee on 7/24/24.
//

import SwiftUI
import FirebaseFunctions
import FirebaseAuth

struct JoseTimer: View {
    @State private var resultMessage = ""
    @State private var authToken: String? = nil

    var body: some View {
        VStack {
            Text("Push Notification Sender")
                .font(.largeTitle)
                .padding()

            Button(action: {
                fetchAuthToken { token in
                    self.authToken = token
                    sendPushNotification(authToken: token)
                }
            }) {
                Text("Send Push Notification")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            Text(resultMessage)
                .padding()
        }
    }

    func fetchAuthToken(completion: @escaping (String?) -> Void) {
        if let currentUser = Auth.auth().currentUser {
            currentUser.getIDToken { token, error in
                if let error = error {
                    print("Error fetching ID token: \(error.localizedDescription)")
                    completion(nil)
                } else {
                    completion(token)
                }
            }
        } else {
            print("No user is signed in")
            completion(nil)
        }
    }

    func sendPushNotification(authToken: String?) {
        guard let authToken = authToken else {
            resultMessage = "No auth token available"
            return
        }

        let functions = Functions.functions(region: "asia-northeast3")
        let data: [String: Any] = [
            "token": "dr-1pK4VmU5oqTSL8deZzy:APA91bFAULxorNfc06w26qYt50yQoJxBvya-Mo4L5fJcp26-1r8wp8S_jiM09OfWhc6H5thS7tAGsG_YvrcDG2j5JYa2-2YPdJZvCGOyyRKZzUA-o2kuD-zHmKnLDUZ1C4l7L_BqhDQ1", // 사용자 FCM 토큰으로 변경
            "title": "Hello",
            "body": "This is a test message"
        ]

        functions.httpsCallable("sendPushNotification").call(data) { result, error in
            if let error = error as NSError? {
                print("Error sending push notification: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    resultMessage = "Error sending push notification: \(error.localizedDescription)"
                }
                return
            }

            if let response = result?.data as? [String: Any], let responseMessage = response["response"] as? String {
                print("Response: \(responseMessage)")
                DispatchQueue.main.async {
                    resultMessage = responseMessage
                }
            } else {
                DispatchQueue.main.async {
                    resultMessage = "Unknown response"
                }
            }
        }
    }
}

#Preview {
    JoseTimer()
}
