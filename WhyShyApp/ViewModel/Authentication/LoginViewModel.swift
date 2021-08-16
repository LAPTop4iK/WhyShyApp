//
//  LoginViewModel.swift
//  WhyShyApp
//
//  Created by Nikita Laptyonok on 16.08.2021.
//

import Foundation

struct LoginViewModel: AuthenticationProtocol {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false
            && password?.isEmpty  == false
    }
}
