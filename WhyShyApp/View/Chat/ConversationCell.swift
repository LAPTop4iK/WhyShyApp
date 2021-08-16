//
//  ConversationCell.swift
//  WhyShy
//
//  Created by Nikita Laptyonok on 09.08.2021.
//

import UIKit

class ConversationCell: UITableViewCell {

    //MARK: - Properties
    
    var conversation: Conversation? {
        didSet { configure() }
    }
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private let timestampLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        label.text = "2h"
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let messageTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configure() {
        guard let conversation = conversation else { return }
        let viewModel = ConversationViewModel(conversation: conversation)
        
        usernameLabel.text = conversation.user.username
        messageTextLabel.text = conversation.message.text
        
        timestampLabel.text = viewModel.timestamp
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
    }
    
    func configureUI() {
        configureProfileImageView()
        addAndConfigureStackView()
        configureTimestampLabel()
    }
    
    func configureProfileImageView() {
        addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
             profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
             profileImageView.widthAnchor.constraint(equalToConstant: K.MessageSizes.cellProfileImage),
             profileImageView.heightAnchor.constraint(equalToConstant: K.MessageSizes.cellProfileImage)])
        profileImageView.layer.cornerRadius = K.MessageSizes.cellProfileImage / 2
    }
    
    func addAndConfigureStackView() {
        let stack = UIStackView(arrangedSubviews: [usernameLabel, messageTextLabel])
        stack.axis = .vertical
        stack.spacing = 4
        
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [stack.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
             stack.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
             stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)])
    }
    
    func configureTimestampLabel() {
        addSubview(timestampLabel)
        timestampLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [timestampLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
             timestampLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)])
        
    }
}
