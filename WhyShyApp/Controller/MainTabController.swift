//
//  MainTabController.swift
//  WhyShyApp
//
//  Created by Nikita Laptyonok on 10.08.2021.
//

import UIKit
import Firebase

class MainTabController: UITabBarController {
    
    //MARK: - Properties
    
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
//        logUserOut()
        authenticateUserAndConfigureUI()
    }
    
    //MARK: - API
    
    func fetchUser() {
        UserService.shared.fetchUser()
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
    
    func logUserOut() {
        do {
            try Auth.auth().signOut()
            print("logUserOut")
        } catch {
            print("logUserOut: faidel to sign out. error: \(error.localizedDescription)")
        }
    }
    
    //MARK: - Selectors
    
    @objc func actionButtonTapped() {
        print(123)
    }
    
    //MARK: - Heplers
    
    func configureViewController() {
        
        let feed = FeedController()
        let nav1 = templateNavigationController(image: UIImage(systemName: "house"), rootViewController: feed)
        
        let explore = ExploreController()
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
