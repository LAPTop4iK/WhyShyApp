//
//  RegistrationViewModel.swift
//  WhyShyApp
//
//  Created by Nikita Laptyonok on 16.08.2021.
//

import Foundation

struct RegistrationViewModel: AuthenticationProtocol {
    var email: String?
    var fullName: String?
    var userName: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false
            && fullName?.isEmpty == false
            && userName?.isEmpty == false
            && password?.isEmpty  == false
            
    }
}
