//
//  MessageViewModel.swift
//  WhyShy
//
//  Created by Nikita Laptyonok on 07.08.2021.
//

import UIKit


struct MessageViewModel {
    
    private let message: Message
    
    var messageBackgroudColor: UIColor {
        return message.isFromCurrentUser ? .systemGray4 : UIColor(named: K.mainColor)!
    }
    
    var messageTextColor: UIColor {
        return message.isFromCurrentUser ? .black : .white
    }
    
    var trailingAnchorActive: Bool {
        return message.isFromCurrentUser
    }
    
    var leadingAnchorActive: Bool {
        return !message.isFromCurrentUser
    }
    
    var shouldHideProfileImage: Bool {
        return message.isFromCurrentUser
    }
    
    var profileImageUrl: URL? {
        guard let user = message.user else { return nil}
        return user.profileImageUrl
    }
    
    init(message: Message) {
        self.message = message
    }
}
