//
//  MainTabController.swift
//  WhyShyApp
//
//  Created by Nikita Laptyonok on 10.08.2021.
//

import UIKit

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
        configureViewController()
        configureUI()
    }
    
    //MARK: - Selectors
    
    @objc func actionButtonTapped() {
        print(123)
    }
    
    //MARK: - Heplers
    
    func configureUI() {
        
        view.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [actionButton.heightAnchor.constraint(equalToConstant: K.UISizes.actionButton),
             actionButton.widthAnchor.constraint(equalToConstant: K.UISizes.actionButton),
             actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -64),
             actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)])
        actionButton.layer.cornerRadius = K.UISizes.actionButton / 2
    }
    
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
    
    func templateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.image = image
        navigationController.navigationBar.barTintColor = .white
        return navigationController
    }
    
}
