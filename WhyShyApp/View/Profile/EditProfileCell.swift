//
//  EditProfileCell.swift
//  WhyShyApp
//
//  Created by Nikita Laptyonok on 15.08.2021.
//

import UIKit

protocol EditProfileCellDelegate: AnyObject {
    func updateUserInfo(_ cell: EditProfileCell)
}

class EditProfileCell: UITableViewCell {
    
    // MARK: - Properties
    
    var viewModel: EditProfileViewModel? {
        didSet { configure() }
    }
    
    weak var delegate: EditProfileCellDelegate?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var infoTextField: UITextField = {
       let textField = UITextField()
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textColor = UIColor(named: K.mainColor)
        textField.addTarget(self, action: #selector(handleUpdateUserInfo), for: .editingDidEnd)
        textField.text = "Test user attribute"
        return textField
    }()
    
    let bioTextView: InputTextView = {
       let textView = InputTextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = UIColor(named: K.mainColor)
        textView.placeholderLabel.text = "Bio"
        return textView
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateUserInfo),
                                               name: UITextView.textDidEndEditingNotification,
                                               object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selector
    
    @objc func handleUpdateUserInfo() {
        delegate?.updateUserInfo(self)
    }
    
    // MARK: - Helpers
    
    func configure() {
        guard let viewModel = viewModel else { return }
        infoTextField.isHidden = viewModel.shouldHideTextField
        bioTextView.isHidden = viewModel.shouldHideTextView
        
        titleLabel.text = viewModel.titleText
        
        infoTextField.text = viewModel.optionValue
        
        bioTextView.placeholderLabel.isHidden = viewModel.shoulHidePlaceholderLabel
        bioTextView.text = viewModel.optionValue
    }
    
    func configureViews() {
        selectionStyle = .none
        configureTitleLabel()
        configureInfoTextField()
        configureBioTextView()
    }
    
    func configureTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [titleLabel.widthAnchor.constraint(equalToConstant: K.Sizes.editTitleLabelWidth),
             titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
             titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)])
    }
    
    func configureInfoTextField() {
        contentView.addSubview(infoTextField)
        infoTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [infoTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
             infoTextField.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16),
             infoTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
             infoTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)])
    }
    
    func configureBioTextView() {
        contentView.addSubview(bioTextView)
        bioTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [bioTextView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
             bioTextView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 14),
             bioTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
             bioTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)])
    }
    
}
