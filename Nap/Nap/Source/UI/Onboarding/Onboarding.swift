//
//  Onboarding.swift
//  Nap
//
//  Created by YunhakLee on 7/24/24.
//

import SwiftUI
import Firebase
import CryptoKit
import AuthenticationServices

struct Onboarding: View {
    @StateObject private var loginViewModel = LoginViewModel()
    @State private var isLoginComplete = false

    var body: some View {
        NavigationView {
            ZStack {
                Image("intro")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    SignInWithAppleButton(
                        onRequest: { request in
                            loginViewModel.nonce = randomNonceString()
                            request.requestedScopes = [.email, .fullName]
                            request.nonce = sha256(loginViewModel.nonce)
                        },
                        onCompletion: { result in
                            switch result {
                            case .success(let authorization):
                                print("Apple Sign-In successful")
                                isLoginComplete = true
                                if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
                                    loginViewModel.authenticate(credential: credential)
                                }
                            case .failure(let error):
                                print("Apple Sign-In failed: \(error.localizedDescription)")
                            }
                        }
                    )
                    .signInWithAppleButtonStyle(.white)
                    .offset(y: 300)
                    .frame(width: 280, height: 45)
                    
                    NavigationLink(destination: Signupname(), isActive: $isLoginComplete) {
                        EmptyView()
                    }
                }
            }
        }
    }
}

class LoginViewModel: ObservableObject {
    @Published var nonce = ""

    func authenticate(credential: ASAuthorizationAppleIDCredential) {
        guard let token = credential.identityToken else {
            print("Error: Unable to fetch identity token")
            return
        }

        guard let tokenString = String(data: token, encoding: .utf8) else {
            print("Error: Unable to convert token to string")
            return
        }

        let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: nonce)
        Auth.auth().signIn(with: firebaseCredential) { result, error in
            if let error = error {
                print("Authentication error: \(error.localizedDescription)")
                return
            }

            print("Successfully signed in")
        }
    }
}

// Helper functions
func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    return hashedData.compactMap { String(format: "%02x", $0) }.joined()
}

func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = String()
    var remainingLength = length

    while remainingLength > 0 {
        let randoms: [UInt8] = (0..<16).map { _ in
            var random: UInt8 = 0
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if errorCode != errSecSuccess {
                fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
            }
            return random
        }

        randoms.forEach { random in
            if remainingLength == 0 {
                return
            }
            if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
            }
        }
    }
    return result
}

#Preview {
    Onboarding()
}
