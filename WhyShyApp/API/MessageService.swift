//
//  MessageService.swift
//  WhyShyApp
//
//  Created by Nikita Laptyonok on 16.08.2021.
//

import Firebase

struct MessageService {
    
    static let shared = MessageService()
    private init() {}
    
    func fetchConversations(completion: @escaping ([Conversation]) -> Void) {
        var conversations = [Conversation]()
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_MESSAGES.child(uid).child("recent-messages").observe(.value) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            print("DEBUG",dictionary)
            let message = Message(dictionary: dictionary)
            print("DEBUG",message)
            UserService.shared.fetchUser(uid: message.chatPartnerId) { user in
                let conversation = Conversation(user: user, message: message)
                conversations.append(conversation)
                completion(conversations)
            }
            
        }
        print(conversations.count)
//        completion(conversations)
    }
    
//    static func fetchConversations(completion: @escaping ([Conversation]) -> Void) {
//    var conversations = [Conversation]()
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//
//        REF_USER_MESSAGES
//        let query = COLLECTION_MESSAGES.document(uid).collection("recent-messages").order(by: "timestamp")
//        query.addSnapshotListener { snapshot, error in
//            snapshot?.documentChanges.forEach({ change in
//                let dictionary = change.document.data()
//                let message = Message(dictionary: dictionary)
//                UserService.shared.fetchUser(uid: message.chatPartnerId) { user in //wrong conversation
//                    let conversation = Conversation(user: user, message: message)
//                    conversations.append(conversation)
//                    completion(conversations)
//                }
//            })
//        }
//    }
    
     func uploadMessage(_ message: String, to user: User, completion: @escaping (DatabaseCompletion)) {
         guard  let currentUid = Auth.auth().currentUser?.uid else { return }
         let values = ["text": message,
                     "fromId": currentUid,
                     "toId": user.uid,
                     "timestamp": Int(NSDate().timeIntervalSince1970)] as [String : Any]
     
        REF_MESSAGES.childByAutoId().updateChildValues(values) { err, ref in
            guard let messageId = ref.key else { return }
            REF_USER_MESSAGES.child(currentUid).child("recent-messages").setValue(values, withCompletionBlock: completion)
            REF_USER_MESSAGES.child(user.uid).child("recent-messages").setValue(values, withCompletionBlock: completion)
            REF_USER_MESSAGES.child(currentUid).child(user.uid).updateChildValues([messageId: 1], withCompletionBlock: completion)
            REF_USER_MESSAGES.child(user.uid).child(currentUid).updateChildValues([messageId: 1], withCompletionBlock: completion)
            }
            
        }
        
//     COLLECTION_MESSAGES.document(currentUid).collection(user.uid).addDocument(data: data) { _ in
//         COLLECTION_MESSAGES.document(user.uid).collection(currentUid).addDocument(data: data, completion: completion)
//
//         COLLECTION_MESSAGES.document(currentUid).collection("recent-messages").document(user.uid).setData(data)
//         COLLECTION_MESSAGES.document(user.uid).collection("recent-messages").document(currentUid).setData(data)
//     }
//    }
    
    func fetchMessages(forUser user: User, completion: @escaping([Message]) -> Void) {
        var messages = [Message]()
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let partnerId = user.uid
        
//        let query = COLLECTION_MESSAGES.document(currentUid).collection(user.uid).order(by: "timestamp")
        REF_USER_MESSAGES.child(partnerId).child(currentUid).observe(.childAdded) { snapshot in
            let messageId = snapshot.key
            self.fetchMessage(withMessageId: messageId) { message in
                messages.append(message)
                completion(messages)
            }
        }
//        query.addSnapshotListener { snapshot, error in
//            snapshot?.documentChanges.forEach({ change in
//                if change.type == .added {
//                    let dictionary = change.document.data()
//                    messages.append(Message(dictionary: dictionary))
//                    completion(messages)
//                }
//            })
//        }
    }
    
    func fetchMessage(withMessageId messageId: String, completion: @escaping(Message) -> Void) {
        REF_MESSAGES.child(messageId).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
            let message = Message(dictionary: dictionary)
            completion(message)
        }
    }

}
