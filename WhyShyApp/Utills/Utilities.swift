//
//  Utilities.swift
//  WhyShyApp
//
//  Created by Nikita Laptyonok on 10.08.2021.
//

import UIKit

class Utilities {
    
    func inputContainerView(withImage image: UIImage?, textField: UITextField) -> UIView {
        let view = UIView()
        let imageView = UIImageView()
        let dividerView = UIView()
        [imageView, view, textField, dividerView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        
        view.addSubview(imageView)
        NSLayoutConstraint.activate(
            [imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
             imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
             imageView.heightAnchor.constraint(equalToConstant: K.UISizes.inputImage),
             imageView.widthAnchor.constraint(equalToConstant: K.UISizes.inputImage)])
        
        view.addSubview(textField)
        NSLayoutConstraint.activate(
            [textField.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
             textField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
             textField.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
        
        dividerView.backgroundColor = .white
        view.addSubview(dividerView)
        NSLayoutConstraint.activate(
            [dividerView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
             dividerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
             dividerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             dividerView.heightAnchor.constraint(equalToConstant: 0.75)])
        
        return view
    }
    
    func textField(withPlaceholder placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.textColor = .white
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor.white])
        return textField
    }
    
    func attributedButton(regularText: String, boldText: String) -> UIButton {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: regularText, attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.white])
        
        attributedTitle.append(NSAttributedString(string: " " + boldText, attributes: [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.white]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        return button
    }
    
}
