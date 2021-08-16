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
        
        var values = ["uid": uid,
                      "caption": caption,
                      "timestamp": Int(NSDate().timeIntervalSince1970),
                      "likes": 0,
                      "reposts": 0] as [String: Any]
        
        switch type {
        case .question:
            REF_QUESTIONS.childByAutoId().updateChildValues(values) { err, ref in
                //update user-question structure after question upload completes
                guard let questionId = ref.key else { return }
                REF_USER_QUESTIONS.child(uid).updateChildValues([questionId: 1], withCompletionBlock: completion)
            }
        case .answer(let question):
            values["answeringTo"] = question.user.username
            REF_QUESTION_ANSWERS.child(question.questionId).childByAutoId().updateChildValues(values) { err, ref in
                guard let answerKey = ref.key else { return }
                REF_USER_ANSWERS.child(uid).updateChildValues([question.questionId: answerKey], withCompletionBlock: completion)
            }
        
        }
    }
    
    func fetchQuestions(completion: @escaping([Question]) -> Void) {
        var questions = [Question]()
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        
        
        REF_USER_FOLLOWING.child(currentUid).observe(.childAdded) { snapshot in
            let followingUid = snapshot.key
            
            REF_USER_QUESTIONS.child(followingUid).observe(.childAdded) { snapshot in
                let questionId = snapshot.key
                
                self.fetchQuestion(withQuestionId: questionId) { question in
                    questions.append(question)
                    completion(questions)
                }
            }
        }
        REF_USER_QUESTIONS.child(currentUid).observe(.childAdded) { snapshot in
            let questionId = snapshot.key
            
            self.fetchQuestion(withQuestionId: questionId) { question in
                questions.append(question)
                completion(questions)
            }
        }
    }
    
    func fetchQuestions(forUser user: User, completion: @escaping([Question]) -> Void) {
        var questions = [Question]()
        REF_USER_QUESTIONS.child(user.uid).observe(.childAdded) { snapshot in
            let questionId = snapshot.key
            
            self.fetchQuestion(withQuestionId: questionId) { question in
                questions.append(question)
                completion(questions)
            }
        }
    }
    
    func fetchQuestion(withQuestionId questionId: String, completion: @escaping(Question) -> Void) {
        REF_QUESTIONS.child(questionId).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            UserService.shared.fetchUser(uid: uid) { user in
                let question = Question(user: user, questionId: questionId, dictionary: dictionary)
                completion(question)
            }
        }
    }
    
    func fetchAnswers(forUser user: User, completion: @escaping([Question]) -> Void) {
        var answers = [Question]()
        
        REF_USER_ANSWERS.child(user.uid).observe(.childAdded) { snapshot in
            let questionKey = snapshot.key
            guard let answerKey = snapshot.value as? String else { return }
            
            REF_QUESTION_ANSWERS.child(questionKey).child(answerKey).observeSingleEvent(of: .value) { snapshot in
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                guard let uid = dictionary["uid"] as? String else { return }
                let answerId = snapshot.key
                UserService.shared.fetchUser(uid: uid) { user in
                    let answer = Question(user: user, questionId: answerId, dictionary: dictionary)
                    answers.append(answer)
                    completion(answers)
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
    
    func fetchLikes(forUser user: User, completion: @escaping([Question]) -> Void) {
        var questions = [Question]()
        
        REF_USER_LIKES.child(user.uid).observe(.childAdded) { snapshot in
            let questionId = snapshot.key
            self.fetchQuestion(withQuestionId: questionId) { likedQuestion in
                var question = likedQuestion
                question.didLike = true
                questions.append(question)
                completion(questions)
            }
        }
    }
    
    func likeQuestion(question: Question, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let likes = question.didLike ? question.likes - 1 : question.likes + 1
        REF_QUESTIONS.child(question.questionId).child("likes").setValue(likes)
        
        if question.didLike {
            // unlike question
            REF_USER_LIKES.child(uid).child(question.questionId).removeValue { err, ref in
                REF_QUESTION_LIKES.child(question.questionId).child(uid).removeValue(completionBlock: completion)
            }
        } else {
            // like question
            REF_USER_LIKES.child(uid).updateChildValues([question.questionId: 1]) { err, ref in
                REF_QUESTION_LIKES.child(question.questionId).updateChildValues([uid: 1], withCompletionBlock: completion)
            }
        }
    }
    
    func checkIfUserLikedQuestion(_ question:  Question, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        REF_USER_LIKES.child(uid).child(question.questionId).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
}
}
