//
//  FeedController.swift
//  WhyShyApp
//
//  Created by Nikita Laptyonok on 10.08.2021.
//

import UIKit
import Firebase

class FeedController: UIViewController {
    
    //MARK: - Properties
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Selectors
    
    @objc func logout() {
        do {
            try Auth.auth().signOut()
            presentLoginScreen()
        } catch {
            print("logout: error signing out")
        }
    }
    
    
    //MARK: - Helpers
    
    func presentLoginScreen() {
        DispatchQueue.main.async {
            let controller = LoginController()
//            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    //MARK: - Heplers
    
    func configureUI() {
        view.backgroundColor = .white
        let image = UIImage(systemName: "person.circle.fill")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain,
                                                           target: self, action: #selector(logout))
        let imageView = UIImageView(image: UIImage(named: K.blueLogo))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
}
