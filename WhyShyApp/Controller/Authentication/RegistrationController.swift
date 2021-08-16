//
//  RegistrationController.swift
//  WhyShyApp
//
//  Created by Nikita Laptyonok on 10.08.2021.
//

import UIKit
import Firebase

class RegistrationController: UIViewController {
    
    //MARK: - Properties
    
    private let imagePicker = UIImagePickerController()
    private var profileImage: UIImage?
    private var viewModel = RegistrationViewModel()
    
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: K.addButton), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleAddProfilePhoto), for: .touchUpInside)
        return button
    }()
    
    private lazy var fullnameContainerView: UIView = {
        let image = UIImage(systemName: "person")
        let view = Utilities().inputContainerView(withImage: image, textField: fullnameTextField)
        return view
    }()
    
    private lazy var usernameContainerView: UIView = {
        let image = UIImage(systemName: "person")
        let view = Utilities().inputContainerView(withImage: image, textField: usernameTextField)
        return view
    }()
    
    private lazy var emailContainerView: UIView = {
        let image = UIImage(systemName: "envelope")
        let view = Utilities().inputContainerView(withImage: image, textField: emailTextField)
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let image = UIImage(systemName: "lock")
        let view = Utilities().inputContainerView(withImage: image, textField: passwordTextField)
        return view
    }()
    
    private let fullnameTextField: UITextField = {
        let textField = Utilities().textField(withPlaceholder: "Full Name")
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .words
        return textField
    }()
    
    private let usernameTextField: UITextField = {
        let textField = Utilities().textField(withPlaceholder: "Username")
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private let emailTextField: UITextField = {
        let textField = Utilities().textField(withPlaceholder: "Email")
        textField.keyboardType = .emailAddress
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = Utilities().textField(withPlaceholder: "Password")
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = Utilities().attributedButton(regularText: "Already have an account?", boldText: "Log In")
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    private let registrationButton: UIButton = {
        let button = Utilities().authButton(withTitle: "Sign Up")
        button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        configureUI()
        configureNotificationObservers()
    }
    
    //MARK: - Selectors
    
    @objc func textDidChange(sender: UITextField) {
        switch sender {
        case emailTextField:
            viewModel.email = sender.text
        case fullnameTextField:
            viewModel.fullName = sender.text
        case usernameTextField:
            viewModel.userName = sender.text
        case passwordTextField:
            viewModel.password = sender.text
        default:
            break
        }
        checkFormStatus()
    }
    
    @objc func keyboardWillShow() {
        if view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 88
        }
    }
    
    @objc func keyboardWillHide() {
        if view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func handleAddProfilePhoto() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleRegistration() {
        guard let profileImage = profileImage else { return }
        
        guard let username = usernameTextField.text?.lowercased(),
              let fullname = fullnameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text else { return }
        showLoader(true,withText: "Signing You UP")

        
       let credentials = AuthCredintials(username: username, fullname: fullname, email: email, password: password, profileImage: profileImage)
        
        AuthService.shared.registerUser(credentials: credentials) { error in
            if let error = error {
                self.showLoader(false)
                self.showError(error.localizedDescription)
                return
            }
            self.showLoader(false)
            guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else { return }
            guard let tab = window.rootViewController as? MainTabController else { return }
            tab.authenticateUserAndConfigureUI()
            self.dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    
    //MARK: - Helpers
    
    func configureUI() {
        configureGradientLayer()
        view.backgroundColor = UIColor(named: K.mainColor)
        configureDontHaveAnAccountButton()
        configurePlusPhotoButton()
        addAndConfigureStackView()
    }
    
    func configureNotificationObservers() {
        [emailTextField, fullnameTextField, usernameTextField, passwordTextField].forEach {
            $0.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    
    func configureDontHaveAnAccountButton() {
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [alreadyHaveAccountButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
             alreadyHaveAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
             alreadyHaveAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)])
    }
    
    func configurePlusPhotoButton() {
        view.addSubview(plusPhotoButton)
        plusPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             plusPhotoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
             plusPhotoButton.widthAnchor.constraint(equalToConstant: K.Sizes.plusButton),
             plusPhotoButton.heightAnchor.constraint(equalToConstant: K.Sizes.plusButton)])
    }
    
    func addAndConfigureStackView() {
        let stack = UIStackView(arrangedSubviews: [fullnameContainerView,
                                                   usernameContainerView,
                                                   emailContainerView,
                                                   passwordContainerView,
                                                   registrationButton])
        stack.axis = .vertical
        stack.spacing = 16
        
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [stack.topAnchor.constraint(equalTo: plusPhotoButton.bottomAnchor),
             stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
             stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)])
    }
}

//MARK: - UIImagePickerControllerDelegate

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImage = info[.editedImage] as? UIImage else { return }
        self.profileImage = profileImage
        
        plusPhotoButton.layer.cornerRadius = K.Sizes.plusButton / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.imageView?.contentMode = .scaleAspectFill
        plusPhotoButton.imageView?.clipsToBounds = true
        
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 3
        self.plusPhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - AuthenticationControllerProtocol
extension RegistrationController: AuthenticationControllerProtocol {
    func checkFormStatus() {
        if viewModel.formIsValid {
            registrationButton.isEnabled = true
            registrationButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        } else {
            registrationButton.isEnabled = false
            registrationButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
    }
}

