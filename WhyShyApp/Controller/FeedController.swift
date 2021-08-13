//
//  FeedController.swift
//  WhyShyApp
//
//  Created by Nikita Laptyonok on 10.08.2021.
//

import UIKit
import SDWebImage
import Firebase

private let reuseIdentifier = "QuestionCell"

class FeedController: UICollectionViewController {
    
    //MARK: - Properties
    
    var user: User? {
        didSet { configureLeftBarButton() }
    }
    
    private var questions = [Question]() {
        didSet { collectionView.reloadData()  }
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchQuestions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - API
    
    func fetchQuestions() {
        QuestionService.shared.fetchQuestions { questions in
            self.questions = questions
            
        }
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
        configureCollectionView()
        configureNavigationBarIcon()
    }
    
    func configureCollectionView() {
        collectionView.register(QuestionCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .white
    }
    
    func configureNavigationBarIcon() {
        let imageView = UIImageView(image: UIImage(named: K.blueLogo))
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: K.Sizes.settingsProfileImage + 20).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: K.Sizes.settingsProfileImage + 40).isActive = true
        navigationItem.titleView = imageView
    }
    
    func configureLeftBarButton() {
        guard let user = user else { return }
        
        let profileImageView = UIImageView()
        profileImageView.heightAnchor.constraint(equalToConstant: K.Sizes.settingsProfileImage).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: K.Sizes.settingsProfileImage).isActive = true
        profileImageView.layer.cornerRadius = K.Sizes.settingsProfileImage / 2
        profileImageView.layer.masksToBounds = true
        
        profileImageView.sd_setImage(with: user.profileImageUrl)

//      navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(logout))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
}

//MARK: - UICollectionViewDelegate/DataSource

extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questions.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? QuestionCell else { return UICollectionViewCell() }
        cell.delegate = self
        cell.question = questions[indexPath.item]
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
}

//MARK: - QuestionCellDelegate

extension FeedController: QuestionCellDelegate {
    func handleProfileImageTapper(_ cell: QuestionCell) {
        guard let user = cell.question?.user else { return }
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
   
}
