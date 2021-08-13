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
    
    func uploadQuestion(caption: String, type: UploadQuestionConfiguration, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["uid": uid,
                      "caption": caption,
                      "timestamp": Int(NSDate().timeIntervalSince1970),
                      "likes": 0,
                      "reposts": 0] as [String: Any]
        
        switch type {
        case .question:
            REF_QUESTIONS.childByAutoId().updateChildValues(values) { err, ref in
                //update user-tweet structure after tweet upload completes
                guard  let questionID = ref.key else { return }
                REF_USER_QUESTIONS.child(uid).updateChildValues([questionID: 1], withCompletionBlock: completion)
            }
        case .answer(let question):
            REF_QUESTION_ANSWERS.child(question.questionId).childByAutoId().updateChildValues(values, withCompletionBlock: completion)
        
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
    
    func fetchAnswers(forQuestion question: Question, completion: @escaping([Question]) -> Void) {
        var questions = [Question]()
        
        REF_QUESTION_ANSWERS.child(question.questionId).observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let questionId = snapshot.key
            UserService.shared.fetchUser(uid: uid) { user in
                let question = Question(user: user, questionId: questionId, dictionary: dictionary)
                questions.append(question)
                completion(questions)
            }
        }
        
    }
}
