//
//  QuestionController.swift
//  WhyShyApp
//
//  Created by Nikita Laptyonok on 13.08.2021.
//

import UIKit

private let reuseIdentifier = "QuestionCell"
private let headerIdentifier = "QuestionHeader"

class QuestionController: UICollectionViewController {
    
    // MARK: - Properties
    
    private let question: Question
    private var actionSheetLauncher: ActionSheetLauncher!
    private var answers = [Question]() {
        didSet { collectionView.reloadData() }
    }
    
    // MARK: - Lifecycle
    
    init(question: Question) {
        self.question = question
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchAnswers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
    
    // MARK: - Heplers
    
    
    func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(QuestionCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(QuestionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }
    
    fileprivate func showActionSheet(forUser user: User) {
        actionSheetLauncher = ActionSheetLauncher(user: user)
        actionSheetLauncher.delegate = self
        actionSheetLauncher.show()
    }
    
    // MARK: - API
    
    func fetchAnswers() {
        QuestionService.shared.fetchAnswers(forQuestion: question) { answers in
            self.answers = answers
        }
    }
}

// MARK: - UICollectionViewDataSourse

extension QuestionController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return answers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! QuestionCell
        cell.question = answers[indexPath.item]
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension QuestionController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! QuestionHeader
        header.question = question
        header.delegate = self
        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension QuestionController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let viewModel = QuestionViewModel(question: question)
        let captionHeight = viewModel.size(forWidth: view.frame.width, andFontSize: 19.6).height
        
        return CGSize(width: view.frame.width, height: captionHeight + 210)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
}

// MARK: - QuestionHeaderDelegate

extension QuestionController: QuestionHeaderDelegate {
    func showActionSheet() {
        
        if question.user.isCurrentUser {
            showActionSheet(forUser: question.user)
        } else {
            UserService.shared.checkIfUserIsFollowed(uid: question.user.uid) { isFollowed in
                var user = self.question.user
                user.isFollowed = isFollowed
                self.showActionSheet(forUser: user)
            }
        }
        
    }
}

// MARK: - ActionSheetLauncherDelegate

extension QuestionController: ActionSheetLauncherDelegate {
    func didSelect(option: ActionSheetOptions) {
        switch option {
        case .follow(let user):
            UserService.shared.followUser(uid: user.uid) { err, ref in
                print("did folow user \(user.username)")
            }
        case .unfollow(let user):
            UserService.shared.unfollowUser(uid: user.uid) { err, ref in
                print("did unfolow user \(user.username)")
            }
        case .report:
            print("report question")
        case .delete:
            print("delete question")
        }
    }
}


