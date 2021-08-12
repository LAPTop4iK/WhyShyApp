//
//  QuestionService.swift
//  WhyShyApp
//
//  Created by Nikita Laptyonok on 11.08.2021.
//

import Firebase

struct QuestionService {
    static let shared = QuestionService()
    private init() {}
    
    func uploadQuestion(caption: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["uid": uid,
                      "caption": caption,
                      "timestamp": Int(NSDate().timeIntervalSince1970),
                      "likes": 0,
                      "shared": 0] as [String: Any]
        
        REF_QUESTIONS.childByAutoId().updateChildValues(values, withCompletionBlock: completion)
    }
    
    func fetchQuestions(completion: @escaping([Question]) -> Void) {
        var questions = [Question]()
        
        REF_QUESTIONS.observe(.childAdded) { snapshot in
            let questionId = snapshot.key
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            
            UserService.shared.fetchUser(uid: uid) { user in
                let question = Question(user: user, questionId: questionId, dictionary: dictionary)
                questions.append(question)
                completion(questions)
            }
        }
    }
    
}
