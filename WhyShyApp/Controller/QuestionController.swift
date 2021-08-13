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
    
    
    // MARK: - Heplers
    
    
    func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(QuestionCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(QuestionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
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
//        header.delegate = self
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


