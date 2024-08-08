//
//  NagiCheckSilentModeView.swift
//  Nap
//
//  Created by YunhakLee on 8/3/24.
//

import SwiftUI
import FirebaseFunctions
import FirebaseAuth
import AuthenticationServices

struct SilentModeCheckView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var timeInterval: Double
    @State var showHome: Bool = false
    @State private var resultMessage = ""
    @State private var authToken: String? = nil
    @State private var moveNext: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: UIScreen.isSE ? 60 : 86)
            Title
            Spacer().frame(height: UIScreen.isSE ? 20 : 50)
            BellImage
            Spacer().frame(minHeight: 30)
            BottomButton
            Spacer().frame(height: 33)
        }
        .padding(.horizontal, 20)
        .background {
            BackgroundImage(image: Image(.basicBackground))
        }
        .toolbar(.hidden, for: .navigationBar)
        .onChange(of: showHome) { _, _ in
            if showHome {
                dismissView()
            }
        }
        .navigationDestination(isPresented: $moveNext) {
            NapProgress(timeInterval: $timeInterval, showHome: $showHome)
        }
    }
}

private extension SilentModeCheckView {
    var Title: some View {
        Text("친구들의 전화 알림을 받기 위해\n무음모드를 꼭 해제해주세요")
            .font(.napLargeTitle)
            .foregroundStyle(.napWhite100)
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .fixedSize()
    }
    
    var BellImage: some View {
        Image("BellCheck")
            .resizable()
            .scaledToFill()
            .frame(width: imageWidth, height: imageHeight)
    }
    
    var BottomButton: some View {
        HStack(spacing: 12) {
            CancelButton
            CheckButton
        }
    }
    
    var CancelButton: some View {
        Button {
            dismissView()
        } label: {
            Text("취소")
                .font(.napTitle2)
                .foregroundStyle(.napWhite60)
                .padding(.vertical, 18)
                .padding(.horizontal, 41)
                .background {
                    RoundedRectangle(cornerRadius: 6)
                        .foregroundStyle(.napWhite10)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(.napWhite10, lineWidth: 1.0)
                }
        }
    }
    
    var CheckButton: some View {
        Button {
            moveNextAndNoti()
        } label: {
            MainButtonLabel(text: "확인했어요")
        }
    }
    
    var imageWidth: CGFloat {
        UIScreen.size.width - 40
    }
    
    var imageHeight: CGFloat {
        imageWidth/9*10
    }
    
    
    func dismissView() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func moveNextAndNoti() {
        moveNext = true
        fetchAuthToken { token in
            self.authToken = token
            sendPushNotification(authToken: token)
        }
    }
    
    
    //---------------------노티관련 함수--------------------------------
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
            "token": "dr-1pK4VmU5oqTSL8deZzy:APA91bFAULxorNfc06w26qYt50yQoJxBvya-Mo4L5fJcp26-1r8wp8S_jiM09OfWhc6H5thS7tAGsG_YvrcDG2j5JYa2-2YPdJZvCGOyyRKZzUA-o2kuD-zHmKnLDUZ1C4l7L_BqhDQ1", // 사용자 FCM 토큰으로 변경, 사용자마다 고유의 토큰값을 가져서 users에 변수로 변경이 필요할거 같다
            "title": "친구가 잠들었어요!",
            "body": "기상 시간이 되면 전화로 낮잠을 깨워주세요!"
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
    //--------------------------------------노티관련 함수----------------------------------------
}

#Preview {
    SilentModeCheckView(timeInterval: .constant(25))
}
