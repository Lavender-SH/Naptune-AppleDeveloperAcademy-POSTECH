//
//  FeedRegisterViewModel.swift
//  Nap
//
//  Created by Jeho Ahn on 8/7/24.
//

import SwiftUI
import PhotosUI
import FirebaseStorage
import Firebase
import FirebaseFirestoreSwift

struct Post: Codable {
    let id: String
    let imageUrl: String
    let sleepComent: String
    let sleepStatusLevel: Double
    let date: Date
}

@Observable
class FeedRegisterViewModel {
    var selectedImage: UIImage?
    var sleepComent: String? = ""
    var sleepStatusLevel: Double?

    func uploadPost(capturedImage: UIImage?, sleepComent: String, sleepStatusLevel: Double) async {
        guard let capturedImage = capturedImage else { return }
        guard let imageUrl = await uploadImage(uiImage: capturedImage) else { return }
        
        let postReference = Firestore.firestore().collection("posts").document()
        let post = Post(id: postReference.documentID, imageUrl: imageUrl, sleepComent: sleepComent, sleepStatusLevel: sleepStatusLevel, date: Date())//id는 업로드한 사용자 uid여야 되는거 아님?
        
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
