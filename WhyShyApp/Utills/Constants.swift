//
//  Constants.swift
//  WhyShyApp
//
//  Created by Nikita Laptyonok on 10.08.2021.
//

import UIKit
import Firebase


let DB_REF = Database.database().reference()
let STORAGE_REF = Storage.storage().reference()
let REF_USERS = DB_REF.child("users")


let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")
let REF_QUESTIONS = DB_REF.child("questions")
let REF_USER_QUESTIONS = DB_REF.child("user-questions")
let REF_USER_FOLLOWERS = DB_REF.child("user-followers")
let REF_USER_FOLLOWING = DB_REF.child("user-following")
let REF_QUESTION_ANSWERS = DB_REF.child("question-answers")
let REF_USER_LIKES = DB_REF.child("user-likes")
let REF_QUESTION_LIKES = DB_REF.child("question-likes")
let REF_NOTIFICATIONS = DB_REF.child("notifications")
let REF_USER_ANSWERS = DB_REF.child("user-answers")


enum K {
    static let addButton = "PlusPhoto"
    static let blueLogo = "BlueLogo"
    static let mainColor = "MainColor"
    
    enum Sizes {
        
        static let notificationFollowButtonWidth: CGFloat = 92
        static let notificationFollowButtonHeight: CGFloat = 32
        static let actionSheetRowHeight: CGFloat = 60
        static let actionSheetImage: CGFloat = 20
        static let actionSheetCancelButtonHeight: CGFloat = 50
        static let exploreProfileImage: CGFloat = 40
        static let notificationProfileImage = exploreProfileImage
        static let profileFollowButtonWidth: CGFloat = 100
        static let profileFollowButtonHeight: CGFloat = 36
        static let profileProfileImage: CGFloat = 80
        static let backButton: CGFloat  = 30
        static let questionCellButton: CGFloat = 20
        static let questionProfileImage: CGFloat = 48
        static let askButtonWidth: CGFloat = 70
        static let askButtonHeight: CGFloat = 32
        static let settingsProfileImage: CGFloat = 32
        static let buttonCornerRadius: CGFloat = 5
        static let inputImage: CGFloat = 24
        static let actionButton: CGFloat = 56
        static let plusButton: CGFloat = 128
        static let logoImageHeight: CGFloat = 150
        static let logoImageWidth: CGFloat = 180
    }
}
