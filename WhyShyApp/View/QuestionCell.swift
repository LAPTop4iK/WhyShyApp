//
//  QuestionCell.swift
//  WhyShyApp
//
//  Created by Nikita Laptyonok on 12.08.2021.
//

import UIKit

protocol QuestionCellDelegate: AnyObject {
    func handleProfileImageTapper(_ cell: QuestionCell)
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
        imageView.heightAnchor.constraint(equalToConstant: K.Sizes.imageQuestionController).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: K.Sizes.imageQuestionController).isActive = true
        imageView.layer.cornerRadius = K.Sizes.imageQuestionController / 2
        
        imageView.backgroundColor = .systemBlue
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.text = "seme test text"
        return label
    }()
    
    private lazy var commentButton: UIButton = {
        let button = Utilities().cellButton(withImage: UIImage(systemName: "bubble.right"))
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
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
    
    @objc func handleCommentTapped() {
        
    }
    
    @objc func handleRepostTapped() {
        
    }
    
    @objc func handleLikeTapped() {
        
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
    }
    
    func configureViews() {
        infoLabel.text = "Eddie Brock @venom"
        infoLabel.font = UIFont.systemFont(ofSize: 14)
        configureProfileImageView()
        addAndConfigureTitleStackView()
        addAndConfigureActionsStackView()
        addAndConfigureUnderlineView()
    }
    
    func configureProfileImageView() {
        addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
             profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)])
    }
    
    func addAndConfigureTitleStackView() {
        let stack = UIStackView(arrangedSubviews: [infoLabel, captionLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 4
        
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [stack.topAnchor.constraint(equalTo: profileImageView.topAnchor),
             stack.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
             stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)])
    }
    
    func addAndConfigureActionsStackView() {
        let stack = UIStackView(arrangedSubviews: [commentButton, repostButton, likeButton, shareButton])
        stack.spacing = 72
        
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
