//
//  UploadQuestionController.swift
//  WhyShyApp
//
//  Created by Nikita Laptyonok on 11.08.2021.
//

import UIKit

class UploadQuestionController: UIViewController {
    
    //MARK: - Properties
    
    private let user: User
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(named: K.mainColor)
        button.setTitle("Ask", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        
        button.frame = CGRect(x: 0, y: 0, width: K.Sizes.askButtonWidth, height: K.Sizes.askButtonHeight)
        button.layer.cornerRadius = K.Sizes.askButtonHeight / 2
        
        button.addTarget(self, action: #selector(handleUploadQuestion), for: .touchUpInside)
        
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.heightAnchor.constraint(equalToConstant: K.Sizes.imageQuestionController).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: K.Sizes.imageQuestionController).isActive = true
        imageView.layer.cornerRadius = K.Sizes.imageQuestionController / 2
        
        imageView.backgroundColor = .red
        
        return imageView
    }()
    
    private let captionTextView = CaptionTextView()
    
    //MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
   //MARK: - Selectors
    
    @objc func handleUploadQuestion() {
        guard let caption = captionTextView.text else { return }
        QuestionService.shared.uploadQuestion(caption: caption) { error, ref in
            if let error = error {
                print("handleUploadQuestion. error: \(error.localizedDescription)")
            }
            
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @objc func handleCandel() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - API
    
    //MARK: - Heplers
    
    func configureUI() {
        view.backgroundColor = .white
        profileImageView.sd_setImage(with: user.profileImageUrl)
        configureNavigationBar()
        addAndConfigureStackView()
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCandel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }
    
    func addAndConfigureStackView() {
        let stack = UIStackView(arrangedSubviews: [profileImageView, captionTextView])
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
             stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
             stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)])
    }
    
}
