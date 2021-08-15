//
//  NotificationService.swift
//  WhyShyApp
//
//  Created by Nikita Laptyonok on 14.08.2021.
//

import Firebase

struct NotificationService {
    static let shared = NotificationService()
    private init() {}
    
    func uploadNotification(type: NotificationType,
                            question: Question? = nil,
                            user: User? = nil) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var values: [String: Any] = ["timestamp": Int(Date().timeIntervalSince1970),
                                     "uid": uid, "type": type.rawValue]
        if let question = question {
            values["questionId"] = question.questionId
            REF_NOTIFICATIONS.child(question.user.uid).childByAutoId().updateChildValues(values)
        } else if let user = user {
            REF_NOTIFICATIONS.child(user.uid).childByAutoId().updateChildValues(values)
            
        }
    }
    
    func fetchNotifications(completion: @escaping([Notification]) -> Void) {
        var notifications = [Notification]()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_NOTIFICATIONS.child(uid).observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            
            UserService.shared.fetchUser(uid: uid) { user in
                let notification = Notification(user: user, dictionary: dictionary)
                notifications.append(notification)
                completion(notifications)
            }
        }
    }
}
