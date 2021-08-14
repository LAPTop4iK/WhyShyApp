//
//  ActionSheetCell.swift
//  WhyShyApp
//
//  Created by Nikita Laptyonok on 14.08.2021.
//

import UIKit

class ActionSheetCell: UITableViewCell {
    
    // MARK: - Properties
    
    var option: ActionSheetOptions? {
        didSet { configure() }
    }
    
    private let optionImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "chevron.forward")
        imageView.clipsToBounds = true
        imageView.widthAnchor.constraint(equalToConstant: K.Sizes.actionSheetImage).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: K.Sizes.actionSheetImage).isActive = true

        return imageView
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Test option"
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let stack = UIStackView(arrangedSubviews: [optionImageView, titleLabel])
        stack.spacing = 12
//        stack.distribution = .fill
        
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [stack.centerYAnchor.constraint(equalTo: centerYAnchor),
             stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configure() {
        titleLabel.text = option?.description
    }
    
    
}
