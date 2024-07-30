//
//  StringConstant.swift
//  Nap
//
//  Created by YunhakLee on 7/24/24.
//

import Foundation

enum StringConstant {
    
    enum NavigationTitle: String {
        case home = "타이머"
        case friend = "친구"
        case feed = "피드"
    }
}

struct Users: Identifiable, Codable {
    var id: String
    var name: String
    var profileimage: String
    var isSleeping: Bool
    var code: Int
    var friends: [String]
    var feed: [String]
}

struct Feeds: Identifiable, Codable {
    var id: String
    var date: String
    var review: String
    var state: String
    var image: String
    var sleepTime: Int
}
