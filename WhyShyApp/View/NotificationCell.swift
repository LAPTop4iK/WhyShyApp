//
//  NotificationCell.swift
//  WhyShyApp
//
//  Created by Nikita Laptyonok on 14.08.2021.
//

import UIKit

protocol NotificationCellDelegate: AnyObject {
    func didTapProfileImage(_ cell: NotificationCell)
    func didTapFollow(_ cell: NotificationCell)
}

class NotificationCell: UITableViewCell {
    
    // MARK: - Properties
    
    var notification: Notification? {
        didSet { configure() }
    }
    
    weak var delegate: NotificationCellDelegate?
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.layer.cornerRadius = 40 / 2
        
        imageView.backgroundColor = .systemBlue
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.setTitleColor(UIColor(named: K.mainColor), for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor(named: K.mainColor)?.cgColor
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
        return button
    }()
    
    private let notificationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Text Notification message"
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stack = UIStackView(arrangedSubviews: [profileImageView, notificationLabel])
        stack.spacing = 8
        stack.alignment = .center
//        #warning("contentview close uiimageview")
        
        contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
             stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
             stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)])
        
        contentView.addSubview(followButton)
        followButton.translatesAutoresizingMaskIntoConstraints = false
         
        NSLayoutConstraint.activate(
            [followButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
             followButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
             followButton.heightAnchor.constraint(equalToConstant: K.Sizes.notificationFollowButtonHeight),
             followButton.widthAnchor.constraint(equalToConstant: K.Sizes.notificationFollowButtonWidth)])
        followButton.layer.cornerRadius = K.Sizes.notificationFollowButtonHeight / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selector
    
    @objc func handleProfileImageTapped() {
        print("TAP")
        delegate?.didTapProfileImage(self)
    }
    
    @objc func handleFollowTapped() {
        delegate?.didTapFollow(self)
    }
    
    // MARK: - Helpers
    
    func configure() {
        guard let notification = notification else { return }
        let viewModel = NotificationViewModel(notification: notification)
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        notificationLabel.attributedText = viewModel.notificationText
        
        followButton.isHidden = viewModel.shouldHideFollowButton
        if !followButton.isHidden {
        followButton.setTitle(viewModel.followButtonString, for: .normal)
        followButton.setTitleColor(viewModel.followButtonColor, for: .normal)
        followButton.layer.borderColor = viewModel.followButtonColor.cgColor
        }
        
    }
}
