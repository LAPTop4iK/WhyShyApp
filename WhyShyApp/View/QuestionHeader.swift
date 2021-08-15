//
//  QuestionHeader.swift
//  WhyShyApp
//
//  Created by Nikita Laptyonok on 13.08.2021.
//

import UIKit

protocol QuestionHeaderDelegate: AnyObject {
    func showActionSheet()
}

class QuestionHeader: UICollectionReusableView {
    
    // MARK: - Properties
    
    var question: Question? {
        didSet { configure() }
    }
    
    weak var delegate: QuestionHeaderDelegate?
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.heightAnchor.constraint(equalToConstant: K.Sizes.questionProfileImage).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: K.Sizes.questionProfileImage).isActive = true
        imageView.layer.cornerRadius = K.Sizes.questionProfileImage / 2
        
        imageView.backgroundColor = .systemBlue
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19)
        label.numberOfLines = 0
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.textAlignment = .left
        return label
    }()
    
    private lazy var optionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .lightGray
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        return button
    }()
    
    private let answerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private let repostsLabel = UILabel()
    private let likesLabel = UILabel()
    
    private lazy var statsView: UIView = {
        let view = UIView()
        let topDivider = UIView()
        topDivider.backgroundColor = .systemGroupedBackground
        view.addSubview(topDivider)
        topDivider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [topDivider.topAnchor.constraint(equalTo: view.topAnchor),
             topDivider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
             topDivider.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             topDivider.heightAnchor.constraint(equalToConstant: 1)])
        
        let stack = UIStackView(arrangedSubviews: [repostsLabel, likesLabel])
        stack.spacing = 12
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
             stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)])
        
        let bottomDivider = UIView()
        bottomDivider.backgroundColor = .systemGroupedBackground
        view.addSubview(bottomDivider)
        bottomDivider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [bottomDivider.bottomAnchor.constraint(equalTo: view.bottomAnchor),
             bottomDivider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
             bottomDivider.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             bottomDivider.heightAnchor.constraint(equalToConstant: 1)])
        
        return view
    }()
    
    
    private lazy var answerButton: UIButton = {
        let button = Utilities().cellButton(withImage: UIImage(systemName: "bubble.right"))
        button.addTarget(self, action: #selector(handleAnswerTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var repostButton: UIButton = {
        let button = Utilities().cellButton(withImage: UIImage(systemName: "arrow.triangle.2.circlepath"))
        button.addTarget(self, action: #selector(handleRepostTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = Utilities().cellButton(withImage: UIImage(systemName: "heart"))
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = Utilities().cellButton(withImage: UIImage(systemName: "square.and.arrow.up"))
        button.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleProfileImageTapped() {
        print("handleProfileImageTapped")
    }
    
    @objc func showActionSheet() {
        delegate?.showActionSheet()
        
    }
    
    @objc func handleAnswerTapped() {
        
    }
    
    @objc func handleRepostTapped() {
        
    }
    
    @objc func handleLikeTapped() {
        
    }
    
    @objc func handleShareTapped() {
        
    }
    
    // MARK: - Helpers
    
    func configure() {
        guard let question = question else { return }
        
        let viewModel = QuestionViewModel(question: question)
        
        captionLabel.text = question.caption
        fullnameLabel.text = question.user.fullname
        usernameLabel.text = viewModel.usernameText
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        dateLabel.text = viewModel.headerTimestamp
        repostsLabel.attributedText = viewModel.repostAttriibutedString
        
        likesLabel.attributedText = viewModel.likesAttriibutedString
        likeButton.setImage(viewModel.likeButtonImage, for: .normal)
        likeButton.tintColor = viewModel.likeButtonTintColor
        
        answerLabel.isHidden = viewModel.shouldHideAnswerLabel
        answerLabel.text = viewModel.answerText
    }
    
    func configureViews() {
        let labelStack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel])
        labelStack.axis = .vertical
        labelStack.spacing = -6
        
        let imageCaptionStack = UIStackView(arrangedSubviews: [profileImageView, labelStack])
        imageCaptionStack.spacing = 12
        
        let stack = UIStackView(arrangedSubviews: [answerLabel, imageCaptionStack])
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillProportionally
        
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [stack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
             stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)])
        
        addSubview(captionLabel)
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [captionLabel.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 12),
             captionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
             captionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)])
        
        addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [dateLabel.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 20),
             dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)])
        
        addSubview(optionButton)
        optionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [optionButton.centerYAnchor.constraint(equalTo: stack.centerYAnchor),
             optionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
             optionButton.widthAnchor.constraint(equalToConstant: 15)])
        
        addSubview(statsView)
        statsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [statsView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 12),
             statsView.trailingAnchor.constraint(equalTo: trailingAnchor),
             statsView.leadingAnchor.constraint(equalTo: leadingAnchor),
             statsView.heightAnchor.constraint(equalToConstant: 40)])
        
        let actionStack = UIStackView(arrangedSubviews: [answerButton, repostButton, likeButton, shareButton])
        actionStack.spacing = 40
        addSubview(actionStack)
        actionStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [actionStack.topAnchor.constraint(equalTo: statsView.bottomAnchor, constant: 16),
             actionStack.centerXAnchor.constraint(equalTo: centerXAnchor)])
    }
    
}
