//
//  UploadQuestionViewModel.swift
//  WhyShyApp
//
//  Created by Nikita Laptyonok on 13.08.2021.
//

import UIKit

enum UploadQuestionConfiguration {
    case question
    case answer(Question)
}

struct UploadQuestionViewModel {
    
    let actionButtonTitle: String
    let placeholderText: String
    var shouldShowReplyLabel: Bool
    var answerText: String?
    
    init(config: UploadQuestionConfiguration) {
        switch config {
        case .question:
            actionButtonTitle = "Ask"
            placeholderText = "What are you interested in?"
            shouldShowReplyLabel = false
        case .answer(let question):
            actionButtonTitle = "Answer"
            placeholderText = "Text your answer"
            shouldShowReplyLabel = true
            answerText = "Answer the question to the user @\(question.user.username)"
        }
    }
}
