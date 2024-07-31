//
//  FirebaseManager.swift
//  Nap
//
//  Created by YunhakLee on 8/1/24.
//

import SwiftUI
import Firebase
import CryptoKit
import AuthenticationServices
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class FirebaseManager {
    private init() { }
    static let shared = FirebaseManager()
    
    var nonce: String = ""
    
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
    
    /// NickName Upload
    
    func createUserDataWithNickname(nickname: String) {
        let db = Firestore.firestore()
        let code = String(Int(arc4random_uniform(900000)) + 100000)
        if let currentUserID = Auth.auth().currentUser?.uid {
            db.collection("users").document("\(currentUserID)").setData(["id": currentUserID, "name": nickname, "profileimage": "", "isSleeping": false, "code": code, "friends": [], "feed": []]) { error in
                if let error = error {
                    print("Error creating document: \(error)")
                } else {
                    print("Document created with ID: \(currentUserID)")
                }
            }
        }
    }
    
    ///Upload Image
    func uploadImage(profileImage: UIImage?) {
        guard let image = profileImage else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("Error: No current user ID found.")
            return
        }
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let profileImageRef = storageRef.child("profile_images/\(currentUserID).jpg")
        
        let uploadTask = profileImageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                return
            }
            
            
            profileImageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    return
                }
                
                guard let downloadURL = url else { return }
                print("Image uploaded successfully. Download URL: \(downloadURL.absoluteString)")
                
                self.updateprofile(downloadURL.absoluteString)
            }
        }
    }
    
    func updateprofile(_ url: String) {
        let db = Firestore.firestore()
        if let currentUserID = Auth.auth().currentUser?.uid {
            db.collection("users").document("\(currentUserID)").setData(["profileimage": url], merge: true) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("Document updated with ID: \(currentUserID)")
                }
            }
        }
    }
}
