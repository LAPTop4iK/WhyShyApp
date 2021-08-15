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
    var shouldShowAnswerLabel: Bool
    var answerText: String?
    
    init(config: UploadQuestionConfiguration) {
        switch config {
        case .question:
            actionButtonTitle = "Ask"
            placeholderText = "What are you interested in?"
            shouldShowAnswerLabel = false
        case .answer(let question):
            actionButtonTitle = "Answer"
            placeholderText = "Text your answer"
            shouldShowAnswerLabel = true
            answerText = "Answer the question to the user @\(question.user.username)"
        }
    }
}
