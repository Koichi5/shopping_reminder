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

//    public let defaultName = "no name"
//
//    public func credentialSignIn(credential: AuthCredential) async -> Void {
//        do {
//            self.auth.signIn(with: credential) { (authResult, error) in
//                if error == nil {
//                    if authResult?.user != nil {
//                        if authResult!.user.displayName == nil {
////                            if user sign in with Apple account, there is no displayName
//                        }
//
//                    }
//                }
//            }
//        }
//    }
    
}
