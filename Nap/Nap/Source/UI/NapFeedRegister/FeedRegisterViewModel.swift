//
//  FeedRegisterViewModel.swift
//  Nap
//
//  Created by 이승현 on 8/7/24.
//

import SwiftUI
import PhotosUI
import FirebaseStorage
import Firebase
import FirebaseFirestoreSwift

struct Post: Codable {
    let id: String
    let nickname: String
    let profileImageUrl: String
    let imageUrl: String
    let sleepComent: String
    let sleepStatusLevel: Double
    let sleepTime: Double
    let date: Date
}

@Observable
class FeedRegisterViewModel {
    var selectedImage: UIImage?
    var sleepComent: String? = ""
    var sleepStatusLevel: Double?

    func uploadPost(capturedImage: UIImage?, sleepComent: String, sleepStatusLevel: Double, sleepTime: Double) async {
        let nickname = UserDefaults.standard.string(forKey: "nickname") ?? "Unknown"
        let profileImageUrl = UserDefaults.standard.string(forKey: "profileImageUrl") ?? ""
        
        guard let capturedImage = capturedImage else { return }
        guard let imageUrl = await uploadImage(uiImage: capturedImage) else { return }
        
        // 현재 로그인된 사용자의 UID 가져오기
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("Error: No current user ID found.")
            return
        }
        
        // Firestore에 저장할 Post 객체 생성
        let post = Post(id: UUID().uuidString, nickname: nickname, profileImageUrl: profileImageUrl, imageUrl: imageUrl, sleepComent: sleepComent, sleepStatusLevel: sleepStatusLevel, sleepTime: sleepTime, date: Date())
        
        // Firestore에 문서 ID를 사용자 UID로 설정하고 데이터 저장
        let postReference = Firestore.firestore().collection("posts").document(UUID().uuidString)
        
        do {
            let encodedData = try Firestore.Encoder().encode(post)
            try await postReference.setData(encodedData)
        } catch {
            print("DEBUG: Failed to upload post with error \(error.localizedDescription)")
        }
    }
    
    func uploadImage(uiImage: UIImage) async -> String? {
        guard let imageData = uiImage.jpegData(compressionQuality: 0.5) else { return nil }
        let fileName = UUID().uuidString
        let reference = Storage.storage().reference(withPath: "/images/\(fileName).jpg")
        
        do {
            let _ = try await reference.putDataAsync(imageData)
            let url = try await reference.downloadURL()
            return url.absoluteString
        } catch {
            print("DEBUG: Failed to upload image with error \(error.localizedDescription)")
            return nil
        }
    }
}

