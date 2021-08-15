//
//  QuestionCell.swift
//  WhyShyApp
//
//  Created by Nikita Laptyonok on 12.08.2021.
//

import UIKit

protocol QuestionCellDelegate: AnyObject {
    func handleProfileImageTapper(_ cell: QuestionCell)
    func handleAnswerTapped(_ cell: QuestionCell)
    func handleLikeTapped(_ cell: QuestionCell)
}

class QuestionCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    var question: Question? {
        didSet { configure() }
    }
    
    weak var delegate: QuestionCellDelegate?
    
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
    
    private let answerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
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
    
    private let infoLabel = UILabel()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc func handleProfileImageTapped() {
        delegate?.handleProfileImageTapper(self)
    }
    
    @objc func handleAnswerTapped() {
        delegate?.handleAnswerTapped(self)
    }
    
    @objc func handleRepostTapped() {
        
    }
    
    @objc func handleLikeTapped() {
        delegate?.handleLikeTapped(self)
    }
    
    @objc func handleShareTapped() {
        
    }
    
    //MARK: - Helpers
    
    func configure() {
        guard let question = question else { return }
        let viewModel = QuestionViewModel(question: question)
        captionLabel.text = question.caption
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        infoLabel.attributedText = viewModel.userInfoText
        likeButton.tintColor = viewModel.likeButtonTintColor
        likeButton.setImage(viewModel.likeButtonImage, for: .normal)
        
        answerLabel.isHidden = viewModel.shouldHideAnswerLabel
        answerLabel.text = viewModel.answerText
    }
    
    func configureViews() {
        infoLabel.text = "Eddie Brock @venom"
        infoLabel.font = UIFont.systemFont(ofSize: 14)
        addAndConfigureTitleStackView()
        addAndConfigureActionsStackView()
        addAndConfigureUnderlineView()
    }
    
    func addAndConfigureTitleStackView() {
        let captionStack = UIStackView(arrangedSubviews: [infoLabel, captionLabel])
        captionStack.axis = .vertical
        captionStack.distribution = .fillProportionally
        captionStack.spacing = 4
        
        let imageCaptionStack = UIStackView(arrangedSubviews: [profileImageView, captionStack])
        imageCaptionStack.distribution = .fillProportionally
        imageCaptionStack.spacing = 12
        imageCaptionStack.alignment = .leading
        
        let stack = UIStackView(arrangedSubviews: [answerLabel, imageCaptionStack])
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillProportionally
        
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate(
            [stack.topAnchor.constraint(equalTo: topAnchor, constant: 4),
             stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
             stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)])
    }
    
    func addAndConfigureActionsStackView() {
        let stack = UIStackView(arrangedSubviews: [answerButton, repostButton, likeButton, shareButton])
//        stack.spacing = 30
//        stack.distribution = .fillEqually
        stack.spacing = 40
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
             stack.centerXAnchor.constraint(equalTo: centerXAnchor)])
    }
    
    func addAndConfigureUnderlineView() {
        let underlineView = UIView()
        underlineView.backgroundColor = .systemGroupedBackground
        addSubview(underlineView)
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [underlineView.leadingAnchor.constraint(equalTo: leadingAnchor),
             underlineView.trailingAnchor.constraint(equalTo: trailingAnchor),
             underlineView.heightAnchor.constraint(equalToConstant: 1)])
    }
    
    
}
