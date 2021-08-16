//
//  MessageCell.swift
//  WhyShy
//
//  Created by Nikita Laptyonok on 07.08.2021.
//

import UIKit

class MessageCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    var message: Message? {
        didSet { configure() }
    }
    
    var bubbleLeadingAnchor: NSLayoutConstraint!
    var bubbleTrailingAnchor: NSLayoutConstraint!
   
    private let profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private let textView: UITextView = {
       let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = .systemFont(ofSize: 16)
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.textColor = .white
        return textView
    }()
    
    private let bubbleContainer: UIView = {
       let view = UIView()
        return view
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configure() {
        guard let message = message else { return }
        let viewModel = MessageViewModel(message: message)
        
        bubbleLeadingAnchor.isActive = viewModel.leadingAnchorActive
        bubbleTrailingAnchor.isActive = viewModel.trailingAnchorActive
        
        bubbleContainer.backgroundColor = viewModel.messageBackgroudColor
        textView.textColor = viewModel.messageTextColor
        textView.text = message.text
        
        profileImageView.isHidden = viewModel.shouldHideProfileImage
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
    }
    
    func configureUI() {
        configureProfileImageView()
        configureBubbleContainer()
        configureTextView()
        
    }
    
    func configureProfileImageView() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(profileImageView)
        NSLayoutConstraint.activate(
            [profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
             profileImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 4),
             profileImageView.heightAnchor.constraint(equalToConstant: K.MessageSizes.smallProfileImage),
             profileImageView.widthAnchor.constraint(equalToConstant: K.MessageSizes.smallProfileImage)])
        profileImageView.layer.cornerRadius = K.MessageSizes.smallProfileImage / 2
    }
    
    func configureBubbleContainer() {
        bubbleContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bubbleContainer)
        NSLayoutConstraint.activate(
            [bubbleContainer.topAnchor.constraint(equalTo: topAnchor),
             bubbleContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
             bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 250)])
        
        bubbleLeadingAnchor = bubbleContainer.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12)
        bubbleTrailingAnchor = bubbleContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        
        bubbleContainer.layer.cornerRadius = K.MessageSizes.bubbleCornerRadius
    }
    
    func configureTextView() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textView)
        NSLayoutConstraint.activate(
            [textView.leadingAnchor.constraint(equalTo: bubbleContainer.leadingAnchor, constant: 12),
             textView.topAnchor.constraint(equalTo: bubbleContainer.topAnchor),
             textView.trailingAnchor.constraint(equalTo: bubbleContainer.trailingAnchor, constant: -12),
             textView.bottomAnchor.constraint(equalTo: bubbleContainer.bottomAnchor, constant: -4)])
    }
    
    
    
}
