//
//  EditProfileFooter.swift
//  WhyShyApp
//
//  Created by Nikita Laptyonok on 16.08.2021.
//

import UIKit

protocol EditProfileFooterDelegate: AnyObject {
    func handleLogout()
}

class EditProfileFooter: UIView {
    
    // MARK: - Properties
    
    weak var delegate: EditProfileFooterDelegate?
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        button.backgroundColor = .red
        button.layer.cornerRadius = 5
        return button
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(logoutButton)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [logoutButton.heightAnchor.constraint(equalToConstant: 50),
             logoutButton.widthAnchor.constraint(equalToConstant: frame.width - 32),
             logoutButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
             logoutButton.centerXAnchor.constraint(equalTo: centerXAnchor),
             logoutButton.centerYAnchor.constraint(equalTo: centerYAnchor)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleLogout() {
        delegate?.handleLogout()
    }
    
    
}
