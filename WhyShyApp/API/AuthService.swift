//
//  AuthService.swift
//  WhyShyApp
//
//  Created by Nikita Laptyonok on 11.08.2021.
//

import UIKit
import Firebase

struct AuthCredintials {
    let username: String
    let fullname: String
    let email: String
    let password: String
    let profileImage: UIImage
}

struct AuthService {
    static let shared = AuthService()
    private init() {}
    
    func logUserIn(withEmail email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func registerUser(credentials: AuthCredintials, completion: @escaping (Error?, DatabaseReference) -> Void) {
        let username = credentials.username
        let fullname = credentials.fullname
        let email = credentials.email
        let password = credentials.password
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else { return }
        let filename = NSUUID().uuidString
        let storageRef = STORAGE_PROFILE_IMAGES.child(filename)
        storageRef.putData(imageData, metadata: nil) { meta, error in
            storageRef.downloadURL { url, error in
                guard let profileImageUrl = url?.absoluteString else { return }
                
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    if let error = error {
                        print("handleRegistration: error is \(error.localizedDescription)")
                        return
                    }
                    
                    guard let uid = result?.user.uid else { return }
                    
                    let values = ["username": username,
                                  "fullname": fullname,
                                  "email": email,
                                  "profileImageUrl": profileImageUrl]
                    
                    REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
                    }
                }
            }
        }
    }

