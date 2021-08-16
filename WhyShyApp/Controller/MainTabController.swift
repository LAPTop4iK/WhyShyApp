//
//  MainTabController.swift
//  WhyShyApp
//
//  Created by Nikita Laptyonok on 10.08.2021.
//

import UIKit
import Firebase

enum ActionButtonConfiguration {
    case question
    case message
}

class MainTabController: UITabBarController {
    
    //MARK: - Properties
    
    private var buttonConfig: ActionButtonConfiguration = .question
    
    var user: User? {
        didSet {
            guard let nav = viewControllers?[0] as? UINavigationController else { return }
            guard let feed = nav.viewControllers.first as? FeedController else { return }
            feed.user = user
        }
    }
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = UIColor(named: K.mainColor)
        button.setImage(UIImage(systemName: "text.badge.plus"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        authenticateUserAndConfigureUI()
    }
    
    //MARK: - API
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.shared.fetchUser(uid: uid) { user in
            self.user = user
        }
    }
    
    func authenticateUserAndConfigureUI() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: false, completion: nil)
            }
        } else {
            configureViewController()
            configureUI()
            fetchUser()
        }
    }
    
    //MARK: - Selectors
    
    @objc func actionButtonTapped() {
        
        let controller: UIViewController
        
        switch buttonConfig {
        case .question:
            guard let user = user else { return }
            controller = UploadQuestionController(user: user, config: .question)
        case .message:
            controller = SearchController(config: .messages)
        }
        let nav = UINavigationController(rootViewController: controller)
        present(nav, animated: true, completion: nil)
    }
    
    //MARK: - Heplers
    
    func configureViewController() {
        
        
        let feed = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let nav1 = templateNavigationController(image: UIImage(systemName: "house"), rootViewController: feed)
        
        let explore = SearchController(config: .userSearch)
        let nav2 = templateNavigationController(image: UIImage(systemName: "magnifyingglass"), rootViewController: explore)
        
        let notifications = NotificationsController()
        let nav3 = templateNavigationController(image:  UIImage(systemName: "heart"), rootViewController: notifications)
        
        let conversations = ConversationsController()
        conversations.tabBarItem.image = UIImage(systemName: "envelope")
        let nav4 = templateNavigationController(image:  UIImage(systemName: "envelope"), rootViewController: conversations)
        
        viewControllers = [nav1, nav2, nav3, nav4]
        
    }
    
    func configureUI() {
        
        view.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [actionButton.heightAnchor.constraint(equalToConstant: K.Sizes.actionButton),
             actionButton.widthAnchor.constraint(equalToConstant: K.Sizes.actionButton),
             actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -64),
             actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)])
        actionButton.layer.cornerRadius = K.Sizes.actionButton / 2
    }
    
    func templateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.image = image
        navigationController.navigationBar.barTintColor = .white
        return navigationController
    }
}

extension MainTabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let index = viewControllers?.firstIndex(of: viewController)
        let image = index == 3 ? UIImage(systemName: "envelope") : UIImage(systemName: "text.badge.plus")
        actionButton.setImage(image, for: .normal)
        buttonConfig = index == 3 ? .message : .question
        
    }
}
