//
//  Notification.swift
//  WhyShyApp
//
//  Created by Nikita Laptyonok on 14.08.2021.
//

import Foundation

enum NotificationType: Int {
    case follow
    case like
    case answer
    case repost
    case mention
}


struct Notification {
    var questionId: String?
    var timestamp: Date!
    var user: User
    var question: Question?
    var type: NotificationType!
    
    init(user: User, dictionary: [String: AnyObject]) {
        self.user = user
//        self.question = question
        
        if let questionId = dictionary["questionId"] as? String {
            self.questionId = questionId
        }
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        if let type = dictionary["type"] as? Int {
            self.type = NotificationType(rawValue: type)
        }
    }
    
}
