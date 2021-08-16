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
        
        imageView.backgroundColor = UIColor(named: K.mainColor)
        
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
        
    }
    
    @objc func showActionSheet() {
        delegate?.showActionSheet()
        
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
//        likeButton.setImage(viewModel.likeButtonImage, for: .normal)
//        likeButton.tintColor = viewModel.likeButtonTintColor
        
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
             optionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
             optionButton.widthAnchor.constraint(equalToConstant: 15)])
        
        addSubview(statsView)
        statsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [statsView.bottomAnchor.constraint(equalTo: bottomAnchor),
             statsView.trailingAnchor.constraint(equalTo: trailingAnchor),
             statsView.leadingAnchor.constraint(equalTo: leadingAnchor),
             statsView.topAnchor.constraint(equalTo: dateLabel.topAnchor, constant: 20)])
    }
    
}
