//
//  CustomInputAccessoryView.swift
//  WhyShy
//
//  Created by Nikita Laptyonok on 07.08.2021.
//

import UIKit

protocol CustomInputAccessoryViewDelegate: AnyObject {
    func inputView(_ inputView: CustomInputAccessoryView, wantToSend message: String)
}

class CustomInputAccessoryView: UIView {
    
    //MARK: - Properties
    
    weak var delegate: CustomInputAccessoryViewDelegate?
    
     private let messageInputTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isScrollEnabled = false
        return textView
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor(named: K.mainColor), for: .normal)
        button.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        return button
    }()
    
    private let placeholderLabel: UILabel = {
       let label = UILabel()
        label.text = "Enter Message"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = .flexibleHeight
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextImputChange), name: UITextView.textDidChangeNotification, object: nil)
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    //MARK: - Selectors
    
    @objc func handleSendMessage() {
        guard let message = messageInputTextView.text else { return }
        delegate?.inputView(self, wantToSend: message)
    }
    
    @objc func handleTextImputChange() {
        placeholderLabel.isHidden = !self.messageInputTextView.text.isEmpty
    }
    
    //MARK: - Helpers
    
    func clearMessageText() {
        messageInputTextView.text = nil
        placeholderLabel.isHidden = false
    }
    
    func configureUI() {
        backgroundColor = .white
        configureShadow()
        configureSendButton()
        configureMessageInputTixtView()
        configurePlaceholder()
    }
    
    func configureShadow() {
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 10
        layer.shadowOffset = .init(width: 0, height: -8)
        layer.shadowColor = UIColor.lightGray.cgColor
    }
    func configureSendButton() {
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sendButton)
        NSLayoutConstraint.activate(
            [sendButton.topAnchor.constraint(equalTo: topAnchor, constant: 4),
             sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
             sendButton.widthAnchor.constraint(equalToConstant: K.MessageSizes.sendButtonSize),
             sendButton.heightAnchor.constraint(equalToConstant: K.MessageSizes.sendButtonSize)])
    }
    
    func configureMessageInputTixtView() {
        messageInputTextView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(messageInputTextView)
        NSLayoutConstraint.activate(
            [messageInputTextView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
             messageInputTextView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -4),
             messageInputTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
             messageInputTextView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8)])
    }
    
    func configurePlaceholder() {
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholderLabel)
        NSLayoutConstraint.activate(
            [placeholderLabel.centerYAnchor.constraint(equalTo: messageInputTextView.centerYAnchor),
             placeholderLabel.leadingAnchor.constraint(equalTo: messageInputTextView.leadingAnchor, constant: 4)])
    }
    
}
