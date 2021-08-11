//
//  User.swift
//  WhyShyApp
//
//  Created by Nikita Laptyonok on 11.08.2021.
//

import Foundation

struct User {
    let username: String
    let fullname: String
    let email: String
    let profileImageUrl: String
    let uid: String
    
    init(uid: String, dictionary: [String: AnyObject]) {
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
    
}
