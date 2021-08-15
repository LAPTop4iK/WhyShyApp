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
        collectionView.refreshControl?.beginRefreshing()
        
        QuestionService.shared.fetchQuestions { questions in
            self.questions = questions
            self.checkIfUserLikedQuestions(questions)
            
            self.questions = questions.sorted(by: { $0.timestamp > $1.timestamp })
            
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    func checkIfUserLikedQuestions(_ questions: [Question]) {
        for (index, question) in questions.enumerated() {
            QuestionService.shared.checkIfUserLikedQuestion(question) { didLike in
                guard didLike == true else { return }
                self.questions[index].didLike = true
            }
            print("ТУТ ИНДЕКС И ОН ",index, " ТУТ РАЗМЕР QUESTIONS и он ", questions.count)
        }
    }
    
    //MARK: - Selectors
    
    @objc func handleRefresh() {
        fetchQuestions()
    }
    
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
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = QuestionController(question: questions[indexPath.item])
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = QuestionViewModel(question: questions[indexPath.item])
        let captionHeight = viewModel.size(forWidth: view.frame.width, andFontSize: 15.7).height
        
        return CGSize(width: view.frame.width, height: captionHeight + 85)
    }
}

//MARK: - QuestionCellDelegate

extension FeedController: QuestionCellDelegate {
    func handleLikeTapped(_ cell: QuestionCell) {
        guard let question = cell.question else { return }
        
        QuestionService.shared.likeQuestion(question: question) { err, ref in
            cell.question?.didLike.toggle()
            let likes = question.didLike ? question.likes - 1 : question.likes + 1
            cell.question?.likes = likes
            
            //only upload notification if question is being liked
            guard !question.didLike else { return }
            NotificationService.shared.uploadNotification(type: .like, question: question)
        }
    }
    
    func handleAnswerTapped(_ cell: QuestionCell) {
        guard let question = cell.question  else { return }
        let controller = UploadQuestionController(user: question.user, config: .answer(question))
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func handleProfileImageTapper(_ cell: QuestionCell) {
        guard let user = cell.question?.user else { return }
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
   
}
