//
//  NotificationsController.swift
//  WhyShyApp
//
//  Created by Nikita Laptyonok on 10.08.2021.
//

import UIKit

class NotificationsController: UIViewController {
    
    //MARK: - Properties
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Heplers
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
    }
}
