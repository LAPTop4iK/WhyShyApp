//
//  CaptionTextView.swift
//  WhyShyApp
//
//  Created by Nikita Laptyonok on 11.08.2021.
//

import UIKit

class CaptionTextView: UITextView {
    
    //MARK: - Properties
    
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.text = "What are you interested in?"
        return label
    }()

    //MARK: - Licecycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureViews() {
        backgroundColor = .white
        font = UIFont.systemFont(ofSize: 16)
        isScrollEnabled = false
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
        configurePlaceholder()
        
    }
    
    func configurePlaceholder() {
        addSubview(placeholderLabel)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
             placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4)])
    }
    
    //MARK: - Selectors
    
    @objc func handleTextInputChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    
}
