//
//  ProfileHeader.swift
//  WhyShyApp
//
//  Created by Nikita Laptyonok on 12.08.2021.
//

import UIKit

protocol ProfileHeaderDelegate: AnyObject {
    func handleDismissal()
    func handleProfileFollow(_ header: ProfileHeader)
    func didSelect(filter: ProfileFilterOptions)
}

class ProfileHeader: UICollectionReusableView {
    
    //MARK: - Properties
    
    var user: User? {
        didSet { configure() }
    }
    
    weak var delegate: ProfileHeaderDelegate?
    
    private let filterBar = ProfileFilterView()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: K.mainColor)
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
             backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
             backButton.widthAnchor.constraint(equalToConstant: K.Sizes.backButton),
             backButton.heightAnchor.constraint(equalToConstant: K.Sizes.backButton)])
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()
    
    private let profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .darkGray
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 4
        return imageView
    }()
    
    let profileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.layer.borderColor = UIColor(named: K.mainColor)?.cgColor
        button.layer.borderWidth = 1.25
        button.setTitleColor(UIColor(named: K.mainColor), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleProfileFollow), for: .touchUpInside)
        return button
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 3
        label.text = "This is a user bio that will span more than one line for test purposes"
        return label
    }()
    
    private let followingLabel: UILabel = {
       let label = UILabel()
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowingTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)
        return label
    }()
    
    private let followersLabel: UILabel = {
       let label = UILabel()
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowersTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)
        return label
    }()
    
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc func handleDismissal() {
        delegate?.handleDismissal()
    }
    
    @objc func handleProfileFollow() {
        delegate?.handleProfileFollow(self)
    }
    
    @objc func handleFollowingTapped() {
        
    }
    
    @objc func handleFollowersTapped() {
        
    }
    
    //MARK: - Helpers
    
    func configure() {
        guard let user = user else { return }
        let viewModel = ProfileHeaderViewModel(user: user)
        
        profileFollowButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        profileFollowButton.setTitleColor(viewModel.atrionButtonColor, for: .normal)
        profileFollowButton.layer.borderColor = viewModel.atrionButtonColor.cgColor
        followersLabel.attributedText = viewModel.followersString
        followingLabel.attributedText = viewModel.followingString
        profileImageView.sd_setImage(with: user.profileImageUrl)
        
        fullnameLabel.text = user.fullname
        usernameLabel.text = viewModel.usernameText
    }
    
    func configureViews() {
        backgroundColor = .white
        filterBar.delegate = self
        configureContainerView()
        configureProfileImageView()
        configureProfileFollowButton()
        createAndConfigureStackViews()
        configureFilterBar()
    }
    
    func configureContainerView() {
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [containerView.topAnchor.constraint(equalTo: topAnchor),
             containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
             containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
             containerView.heightAnchor.constraint(equalToConstant: 110)])
    }
    
    func configureProfileImageView() {
        addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [profileImageView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant:  -24),
             profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
             profileImageView.heightAnchor.constraint(equalToConstant: K.Sizes.profileProfileImage),
             profileImageView.widthAnchor.constraint(equalToConstant: K.Sizes.profileProfileImage)])
        
        profileImageView.layer.cornerRadius =  K.Sizes.profileProfileImage / 2
    }
    
    func configureProfileFollowButton() {
        addSubview(profileFollowButton)
        profileFollowButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [profileFollowButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 12),
             profileFollowButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
             profileFollowButton.widthAnchor.constraint(equalToConstant: K.Sizes.profileFollowButtonWidth),
             profileFollowButton.heightAnchor.constraint(equalToConstant: K.Sizes.profileFollowButtonHeight)])
        
        profileFollowButton.layer.cornerRadius =  K.Sizes.profileFollowButtonHeight / 2
    }
    
    func createAndConfigureStackViews() {
        let userDetailsStack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel, bioLabel])
        userDetailsStack.axis = .vertical
        userDetailsStack.distribution = .fillProportionally
        userDetailsStack.spacing = 4
        
        addSubview(userDetailsStack)
        userDetailsStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [userDetailsStack.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
             userDetailsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
             userDetailsStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)])
        
        let followStack = UIStackView(arrangedSubviews: [followingLabel, followersLabel])
        followStack.distribution = .fillEqually
        followStack.spacing = 8
        
        addSubview(followStack)
        followStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [followStack.topAnchor.constraint(equalTo: userDetailsStack.bottomAnchor, constant: 8),
             followStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12)])
    }
    
    func configureFilterBar() {
        addSubview(filterBar)
        filterBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [filterBar.leadingAnchor.constraint(equalTo: leadingAnchor),
             filterBar.bottomAnchor.constraint(equalTo: bottomAnchor),
             filterBar.trailingAnchor.constraint(equalTo: trailingAnchor),
             filterBar.heightAnchor.constraint(equalToConstant: 50)])
    }
    
    
    
    func addAndConfigureFollowStackView() {
        
    }
}

//MARK: - ProfileFilterViewDelegate

extension ProfileHeader: ProfileFilterViewDelegate {
    func filterView(_ view: ProfileFilterView, didSelect index: Int) {
        guard let filter = ProfileFilterOptions(rawValue: index) else { return }
        delegate?.didSelect(filter: filter)
    }
}

