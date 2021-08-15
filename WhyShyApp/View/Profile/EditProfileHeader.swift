//
//  EditProfileHeader.swift
//  WhyShyApp
//
//  Created by Nikita Laptyonok on 15.08.2021.
//

import UIKit

protocol EditProfileHeaderDelegate: AnyObject {
    func didTapChangeProfilePhoto()
}

class EditProfileHeader: UIView {
    
    // MARK: - Properties
    
    private let user: User
    weak var delegate: EditProfileHeaderDelegate?
    
    let profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        imageView.layer.borderWidth = 3.0
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    private lazy var changePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change Profile Photo", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleChangeProfilePhoto), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(frame: .zero)
        backgroundColor = UIColor(named: K.mainColor)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selector
    
    @objc func handleChangeProfilePhoto() {
        delegate?.didTapChangeProfilePhoto()
    }
    
    // MARK: - Helpers
    
    func configureViews() {
        configureProfileImageView()
        configureChangePhotoButton()
    }
    
    func configureProfileImageView() {
        profileImageView.sd_setImage(with: user.profileImageUrl)
        addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -16),
             profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
             profileImageView.heightAnchor.constraint(equalToConstant: K.Sizes.editProfileImageView),
             profileImageView.widthAnchor.constraint(equalToConstant: K.Sizes.editProfileImageView)])
        profileImageView.layer.cornerRadius = K.Sizes.editProfileImageView / 2
    }
    
    func configureChangePhotoButton() {
        addSubview(changePhotoButton)
        changePhotoButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [changePhotoButton.centerXAnchor.constraint(equalTo: centerXAnchor),
             changePhotoButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8)])
    }
}
