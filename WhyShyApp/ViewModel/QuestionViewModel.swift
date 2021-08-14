//
//  QuestionViewModel.swift
//  WhyShyApp
//
//  Created by Nikita Laptyonok on 12.08.2021.
//

import UIKit

struct QuestionViewModel {
    
    let question: Question
    let user: User
    
    var profileImageUrl: URL? {
        return user.profileImageUrl
    }
    
    var timestamp: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: question.timestamp, to: now) ?? "2s"
    }
    
    var usernameText: String {
        return "@\(user.username)"
    }
    
    var headerTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a・dd/MM/yyyy"
        return formatter.string(from: question.timestamp)
    }
    
    var repostAttriibutedString: NSAttributedString? {
        return attributedText(withValue: question.repostCount, text: "Reposts")
    }
    
    var likesAttriibutedString: NSAttributedString? {
        return attributedText(withValue: question.likes, text: "Likes")
    }
    
    
    var userInfoText: NSAttributedString {
        let title = NSMutableAttributedString(string: user.fullname,
                                              attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        title.append(NSAttributedString(string: " @\(user.username)",
                                        attributes: [.font: UIFont.systemFont(ofSize: 14),
                                                     .foregroundColor: UIColor.lightGray]))
        title.append(NSAttributedString(string: "・\(timestamp)",
                                        attributes: [.font: UIFont.systemFont(ofSize: 14),
                                                     .foregroundColor: UIColor.lightGray]))
        return title
    }
    
    var likeButtonTintColor: UIColor {
        return question.didLike ? .red : .darkGray
    }
    
    var likeButtonImage: UIImage {
        let imageName = question.didLike ? "heart.fill" : "heart"
        return UIImage(systemName: imageName)!
    }
    
    init(question: Question) {
        self.question = question
        self.user = question.user
    }
    
    fileprivate func attributedText(withValue value: Int, text: String) -> NSAttributedString {
         let attributedTitle = NSMutableAttributedString(string: "\(value)",
                                                         attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
         attributedTitle.append(NSAttributedString(string: " \(text)",
                                                   attributes: [.font: UIFont.systemFont(ofSize: 14),
                                                                .foregroundColor: UIColor.lightGray]))
         return attributedTitle
     }
    
    func size(forWidth width: CGFloat, andFontSize fontSize: CGFloat) -> CGSize {
        let measurementLabel = UILabel()
        measurementLabel.font = UIFont.systemFont(ofSize: fontSize)
        measurementLabel.text = question.caption
        measurementLabel.numberOfLines = 0
        measurementLabel.lineBreakMode = .byWordWrapping
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false
        measurementLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        return measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
}
