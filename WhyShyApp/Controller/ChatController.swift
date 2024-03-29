//
//  ChatController.swift
//  WhyShy
//
//  Created by Nikita Laptyonok on 07.08.2021.
//

import UIKit

private let reuseIdentifier = "MessageCell"

class ChatController: UICollectionViewController {

    //MARK: - Properties
    
    private let user: User
    private var messages = [Message]() {
        didSet { collectionView.reloadData() }
    }
    
    private lazy var customInputView: CustomInputAccessoryView = {
        let inputView = CustomInputAccessoryView(frame: CGRect(x: 0, y: 0,
                                                        width: view.frame.width, height: 50))
        inputView.delegate = self
        return inputView
    }()
    
    //MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchMessage()
        print("ChatController vdl: user is \(user.username)")
    }
    
    override var inputAccessoryView: UIView? {
        get { return customInputView }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    //MARK: - API
    
    func fetchMessage() {
        showLoader(true)
        MessageService.shared.fetchMessages(forUser: user) { messages in
            print("колличество сообщений", messages.count)
            
            self.showLoader(false)
            self.messages = messages
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: [0, self.messages.count - 1], at: .bottom, animated: true)
        }

    }
   
    //MARK: - Helpers
    
    func configureUI() {
        collectionView.backgroundColor = .white
        configureNavigationBar(withTitle: user.username, preferLargeTitle: false)

        collectionView.register(MessageCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.alwaysBounceVertical = true
        
        collectionView.keyboardDismissMode = .interactive
    }
    
}

extension ChatController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MessageCollectionViewCell
        cell.message = messages[indexPath.row]
        cell.message?.user = user
        return cell
    }
}

extension ChatController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let guessSizeCell = MessageCollectionViewCell(frame: frame)
        guessSizeCell.message = messages[indexPath.row]
        guessSizeCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let guessSize = guessSizeCell.systemLayoutSizeFitting(targetSize)
        
        return .init(width: view.frame.width, height: guessSize.height)
    }
}

extension ChatController: CustomInputAccessoryViewDelegate {
    func inputView(_ inputView: CustomInputAccessoryView, wantToSend message: String) {
        MessageService.shared.uploadMessage(message, to: user) { error, ref in
            if let error = error {
                print("inputView: failed to upload message with error \(error.localizedDescription)")
                return
            }
            inputView.clearMessageText()
        }
    }
}
