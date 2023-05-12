//
//  AuthModel.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/03.
//

import Foundation
import FirebaseAuth
import FirebaseCore

class AuthModel {
    static let shared = AuthModel()
    
    private let auth = Auth.auth()
    
    public func getCurrentUser() -> User? {
        return auth.currentUser
    }
}
