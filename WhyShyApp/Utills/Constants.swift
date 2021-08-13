//
//  Constants.swift
//  WhyShyApp
//
//  Created by Nikita Laptyonok on 10.08.2021.
//

import UIKit
import Firebase


let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")

let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")
let REF_QUESTIONS = DB_REF.child("questions")
let REF_USER_QUESTIONS = DB_REF.child("user-questions")

enum K {
    static let addButton = "PlusPhoto"
    static let blueLogo = "BlueLogo"
    static let mainColor = "MainColor"
    
    enum Sizes {
        static let profileFollowButtonWidth: CGFloat = 100
        static let profileFollowButtonHeight: CGFloat = 36
        static let profileProfileImage: CGFloat = 80
        static let backButton: CGFloat  = 30
        static let questionCellButton: CGFloat = 20
        static let imageQuestionController: CGFloat = 48
        static let askButtonWidth: CGFloat = 64
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
