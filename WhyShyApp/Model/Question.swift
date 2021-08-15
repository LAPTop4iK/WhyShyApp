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
    var likes: Int
    let repostCount: Int
    var timestamp: Date!
    let user: User
    var didLike = false 
    
    init(user: User, questionId: String, dictionary: [String: Any]) {
        self.user = user
        self.questionId = questionId
        
        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.repostCount = dictionary["reposts"] as? Int ?? 0
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
    }
}
