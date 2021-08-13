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
        return attributedText(withValue: user.stats?.followers ?? 0, text: "followers")
    }
    
    var followingString: NSAttributedString? {
        return attributedText(withValue: user.stats?.following ?? 0, text: "following")
    }
    
    var atrionButtonColor: UIColor {
        var titleColor = UIColor(named: K.mainColor)
        if user.isFollowed {
            titleColor = .systemGreen
        }
        return titleColor ?? .systemBlue
    }
    
    var actionButtonTitle: String {
        var title = "Loading"
        if user.isCurrentUser {
            title = "Edit Profile"
        }
        if !user.isFollowed && !user.isCurrentUser {
            title = "Follow"
        }
        
        if user.isFollowed {
            title = "Following"
        }
        return title
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
