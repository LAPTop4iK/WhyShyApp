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

enum K {
    static let addButton = "PlusPhoto"
    static let blueLogo = "BlueLogo"
    static let mainColor = "MainColor"
    
    enum Sizes {
        static let buttonCornerRadius: CGFloat = 5
        static let inputImage: CGFloat = 24
        static let actionButton: CGFloat = 56
        static let plusButton: CGFloat = 128
        static let logoImageHeight: CGFloat = 150
        static let logoImageWidth: CGFloat = 180
    }
}
