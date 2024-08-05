//
//  PushNotificationManager.swift
//  Nap
//
//  Created by Jeho Ahn on 8/1/24.
//

import Foundation

class PushNotificationManager {
    static func sendPushNotification() {
        let receiverFCM = "dqS2bbUUv0czlWF84Sk0cO:APA91bFukqpVmXqx6SNFd_dDKB0Xqc2WZO6OGf-2hIvkf9FTtTLbDXQVLJEyysNVrFgA0wGfJBXLFPYg2_xbxN2LnbU0IU6o93WdapzZb2EFP0UGTmzeRuATP9wFRpKM6x8hHiB3EbJs"
        let serverKey = ""
        
        let url = URL(string: "https://fcm.googleapis.com/v1/projects/lavenderphamhani/messages:send")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Set the request headers
        request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Set the request body data
        let requestBody: [String: Any] = [
            "message": [
              "token": receiverFCM,
              "notification": [
                "title": "Hello",
                "body": "This is a test message"
              ]
            ]
        ]
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) {
            request.httpBody = jsonData
            
            // Send the request
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                if let data = data {
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("Response: \(responseString)")
                    }
                }
            }.resume()
        }
    }
}
