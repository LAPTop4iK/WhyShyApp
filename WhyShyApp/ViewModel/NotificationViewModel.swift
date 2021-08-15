//
//  NotificationViewModel.swift
//  WhyShyApp
//
//  Created by Nikita Laptyonok on 14.08.2021.
//

import UIKit

struct NotificationViewModel {
    
    private let notification: Notification
    private let type: NotificationType
    private let user: User
    
    var timestampString: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: notification.timestamp, to: now) ?? "2s"
    }
    
    var notificationMessage: String {
        switch type {
        case .follow: return " started following you"
        case .like: return " liked your question"
        case .answer: return " answered one of your question"
        case .repost: return " repost your question"
        case .mention: return " mentioned you in a question"
        }
    }
    
    var notificationText: NSAttributedString? {
        guard let timestamp = timestampString else { return nil}
        let attributedText = NSMutableAttributedString(string: user.username,
                                                       attributes: [.font: UIFont.boldSystemFont(ofSize: 12)])
        attributedText.append(NSAttributedString(string: notificationMessage,
                                                 attributes: [.font: UIFont.systemFont(ofSize: 12)]))
        attributedText.append(NSAttributedString(string: " \(timestamp)",
                                                 attributes: [.font: UIFont.systemFont(ofSize: 12),
                                                              .foregroundColor: UIColor.lightGray]))
        
        return attributedText
    }
    
    var profileImageUrl: URL? {
        return user.profileImageUrl
    }
    
    var shouldHideFollowButton: Bool {
        return type != .follow
    }
    
    var followButtonColor: UIColor {
        var titleColor = UIColor(named: K.mainColor)
        if user.isFollowed {
            titleColor = .systemGreen
        }
        return titleColor ?? .systemBlue
    }
    
    var followButtonString: String {
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
        
        init(notification: Notification) {
            self.notification = notification
            self.type = notification.type
            self.user = notification.user
        }
}
