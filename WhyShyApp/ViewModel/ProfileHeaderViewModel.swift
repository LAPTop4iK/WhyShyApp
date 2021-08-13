//
//  ProfileHeaderViewModel.swift
//  WhyShyApp
//
//  Created by Nikita Laptyonok on 12.08.2021.
//

import UIKit

enum ProfileFilterOptions: Int, CaseIterable {
    case questions
    case replies
    case likes
    
    var description: String {
        switch self {
        case .questions: return "Questions"
        case .replies: return "Reply"
        case .likes: return "Likes"
        }
    }
}

struct ProfileHeaderViewModel {
    
    private let user: User
    
    let usernameText: String
    
    var followersString: NSAttributedString? {
        return attributedText(withValue: 0, text: "followers")
    }
    
    var followingString: NSAttributedString? {
        return attributedText(withValue: 2, text: "following")
    }
    
    var atrionButtonTitle: String {
        if user.isCurrentUser {
            return "Edit Profile"
        } else {
            return "Follow"
        }
        // if user is current user then set to edit profile
        //else figure out follow/unfollow
    }
    
    init(user: User) {
        self.user = user
        self.usernameText = "@" + user.username
    }
    
   fileprivate func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)",
                                                        attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSAttributedString(string: " \(text)",
                                                  attributes: [.font: UIFont.systemFont(ofSize: 14),
                                                               .foregroundColor: UIColor.lightGray]))
        return attributedTitle
    }
}
