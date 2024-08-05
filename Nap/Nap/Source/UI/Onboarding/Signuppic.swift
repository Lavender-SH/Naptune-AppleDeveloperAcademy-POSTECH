//
//  Signuppic.swift
//  Nap
//
//  Created by Jeho Ahn on 7/26/24.
//

import SwiftUI
import PhotosUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth


struct Signuppic: View {
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage? = nil
    @State private var issignup = false
    
    var body: some View {
        VStack(spacing: 20) {
            
            HStack {
                Text("1")
                    .font(.headline)
                    .foregroundColor(Color.purple)
                Text("2 프로필")
                    .font(.headline)
                    .foregroundColor(Color.purple)
                Spacer()
            }
            .padding(.leading)
            
            Text("친구들이 나를 알아볼 수 있는 사진으로 설정하면 좋아요")
                .font(.subheadline)
                .foregroundColor(Color.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            Text("프로필 사진을 등록해요")
                .font(.title2)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            Button(action: {
                showImagePicker = true
            }) {
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                } else {
                    ZStack {
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 200, height: 200)
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                    }
                }
            }
            .padding(.horizontal)
            
            Text("프로필 미리보기")
                .font(.footnote)
                .foregroundColor(Color.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            HStack {
                if let image = selectedImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.blue)
                                }
                
                VStack(alignment: .leading) {
                    Text("충전하는 중")
                        .font(.body)
                        .foregroundColor(.gray)
                    Text("자두자두줄린해시")
                        .font(.body)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Text("24:50")
                    .font(.body)
                    .foregroundColor(.blue)
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(10)
            .padding(.horizontal)
            
            Spacer()
            
            Button(action: {
                uploadImage()
                //updateprofile()
            }) {
                Text("다음")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage)
        }
    }
    func uploadImage() {
            guard let image = selectedImage else { return }
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
                    
                    updateprofile(downloadURL.absoluteString)
                }
            }
        }
    func updateprofile(_ url: String) {
        let db = Firestore.firestore()
        if let currentUserID = Auth.auth().currentUser?.uid {
            db.collection("users").document("\(currentUserID)").setData(["profileimage": "\(currentUserID).jpg"], merge: true) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("Document updated with ID: \(currentUserID)")
                }
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

#Preview {
    Signuppic()
}
