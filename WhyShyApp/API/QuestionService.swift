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
        let ref = REF_QUESTIONS.childByAutoId()
        
        ref.updateChildValues(values) { error, ref in
            //update user-tweet structure after tweet upload completes
            guard  let questionID = ref.key else { return }
            REF_USER_QUESTIONS.child(uid).updateChildValues([questionID: 1], withCompletionBlock: completion)
        }
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
    
    func fetchQuestions(forUser user: User, completion: @escaping([Question]) -> Void) {
        var questions = [Question]()
        REF_USER_QUESTIONS.child(user.uid).observe(.childAdded) { snapshot in
            let questionId = snapshot.key
            
            REF_QUESTIONS.child(questionId).observeSingleEvent(of: .value) { snapshot in
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
}
