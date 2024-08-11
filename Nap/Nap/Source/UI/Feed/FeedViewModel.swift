//
//  FeedViewModel.swift
//  Nap
//
//  Created by 이승현 on 8/11/24.
//

//import SwiftUI
//import Firebase
//import FirebaseFirestore
//
//class FeedViewModel: ObservableObject {
//    @Published var posts: [Post] = []
//
//    init() {
//        fetchPosts()
//    }
//
//    func fetchPosts() {
//        let db = Firestore.firestore()
//        db.collection("posts").order(by: "date", descending: true).getDocuments { snapshot, error in
//            if let error = error {
//                print("Error getting documents: \(error)")
//                return
//            }
//            self.posts = snapshot?.documents.compactMap { document -> Post? in
//                try? document.data(as: Post.self)
//            } ?? []
//        }
//    }
//}

import SwiftUI
import Firebase
import FirebaseFirestore

class FeedViewModel: ObservableObject {
    @Published var posts: [Post] = []

    init() {
        fetchPosts()
    }

    func fetchPosts() {
        let db = Firestore.firestore()
        db.collection("posts")
          //.whereField("nickname", isEqualTo: "라벤더")
          .order(by: "date", descending: true)
          .getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            self.posts = snapshot?.documents.compactMap { document -> Post? in
                try? document.data(as: Post.self)
            } ?? []
        }
    }
}



