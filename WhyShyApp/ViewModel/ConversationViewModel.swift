//
//  ConversationViewModel.swift
//  WhyShy
//
//  Created by Nikita Laptyonok on 09.08.2021.
//

import Foundation

struct ConversationViewModel {
    
    private let conversation: Conversation
    
    var profileImageUrl: URL? {
        return conversation.user.profileImageUrl
    }
    
    var timestamp: String {
        guard let date = conversation.message.timestamp else { return "00:00:00"}
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date)
    }
    
    init(conversation: Conversation) {
        self.conversation = conversation
    }
}

