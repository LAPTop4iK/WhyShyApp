//
//  Question.swift
//  WhyShyApp
//
//  Created by Nikita Laptyonok on 12.08.2021.
//

import Foundation

struct Question {
    let questionId: String
    let caption: String
    let likes: Int
    let sharedCount: Int
    var timestamp: Date!
    let uid: String
    let user: User
    
    init(user: User, questionId: String, dictionary: [String: Any]) {
        self.user = user
        self.questionId = questionId
        
        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.sharedCount = dictionary["shared"] as? Int ?? 0
        self.uid = dictionary["uid"] as? String ?? ""
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
    }
}
