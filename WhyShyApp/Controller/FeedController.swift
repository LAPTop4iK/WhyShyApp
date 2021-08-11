//
//  FeedController.swift
//  WhyShyApp
//
//  Created by Nikita Laptyonok on 10.08.2021.
//

import UIKit

class FeedController: UIViewController {
    
    //MARK: - Properties
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Heplers
    
    func configureUI() {
        view.backgroundColor = .white
        let imageView = UIImageView(image: UIImage(named: K.blueLogo))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
}
