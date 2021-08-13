//
//  UserCell.swift
//  WhyShyApp
//
//  Created by Nikita Laptyonok on 13.08.2021.
//

import UIKit

class UserCell: UITableViewCell {
    
    // MARK: - Properties
    
    var user: User? {
        didSet { configure() }
    }
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.heightAnchor.constraint(equalToConstant: K.Sizes.exploreProfileImage).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: K.Sizes.exploreProfileImage).isActive = true
        imageView.layer.cornerRadius = K.Sizes.exploreProfileImage / 2
        
        imageView.backgroundColor = .systemBlue
        
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Username"
        return label
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Fullname"
        return label
    }()
    
    // MARK: - Licecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configure() {
        guard let user = user else { return }
        profileImageView.sd_setImage(with: user.profileImageUrl)
        
        usernameLabel.text = user.username
        fullnameLabel.text = user.fullname
    }
    
    func configureViews() {
        configureProfileImageView()
        createAndConfigureUserInfoStackView()
    }
    
    func configureProfileImageView() {
        addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
             profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12)])
    }
    
    func createAndConfigureUserInfoStackView() {
        let stack = UIStackView(arrangedSubviews: [usernameLabel, fullnameLabel])
        stack.axis = .vertical
        stack.spacing = 2
        
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [stack.centerYAnchor.constraint(equalTo: centerYAnchor),
             stack.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12)])
    }
    
}
