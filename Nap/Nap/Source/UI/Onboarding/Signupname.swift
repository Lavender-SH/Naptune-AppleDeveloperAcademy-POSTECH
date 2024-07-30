//
//  Signupname.swift
//  Nap
//
//  Created by Jeho Ahn on 7/26/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct Signupname: View {
    @State private var nickname: String = ""
    @State private var isNextActive = false
    @State private var selectedProfile = ""
    @State private var awakesleep = false
    let code = String(Int(arc4random_uniform(900000)) + 100000)
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                Text("1 닉네임")
                    .font(.headline)
                    .foregroundColor(Color.purple)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                
                Text("친구들이 나를 알아볼 수 있도록 닉네임을 설정해주세요")
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                Text("닉네임을 알려주세요")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                TextField("예시) 낮잠공주나기", text: $nickname)
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                Text("* 닉네임은 2 - 10글자로 작성해주세요 (공백제외)")
                    .font(.footnote)
                    .foregroundColor(Color.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                NavigationLink(destination: Signuppic(), isActive: $isNextActive) {
                    Button(action: {
                        isNextActive = true
                        createUserData()
                    }) {
                        Text("다음")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(nickname.count >= 2 && nickname.count <= 10 ? Color.purple : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .disabled(nickname.count < 2 || nickname.count > 10)
                    
                    Spacer()
                }
                .background(Color.black.edgesIgnoringSafeArea(.all))
            }
        }
    }
    func createUserData() {
        let db = Firestore.firestore()
        if let currentUserID = Auth.auth().currentUser?.uid {
            db.collection("users").document("\(currentUserID)").setData(["id": currentUserID, "name": nickname, "profileimage": selectedProfile, "isSleeping": awakesleep, "code": code, "friends": [], "feed": []]) { error in
                if let error = error {
                    print("Error creating document: \(error)")
                } else {
                    print("Document created with ID: \(currentUserID)")
                }
            }
        }
    }
}

#Preview {
    Signupname()
}
