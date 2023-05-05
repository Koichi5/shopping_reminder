//
//  AuthViewModel.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/03.
//

import Foundation
import FirebaseAuth
import FirebaseCore

class AuthViewModel: ObservableObject {
    
    @Published var isRegisterSuccess: Bool = false
    static let shared = AuthViewModel()
    private var auth = Auth.auth()
    
//    let initialCategories = [
//        Category(name: "Grocery", color: CategoryColor.red),
//        Category(name: "Household", color: CategoryColor.blue),
//        Category(name: "Electronics", color: CategoryColor.green)
//    ]
    
    func createUserWithEmailAndPassword(email: String, password: String) -> Void {
        auth.createUser(withEmail: email, password: password) { result, error in
            if (result?.user != nil) {
                FirebaseUserRepository().addFirebaseUser(user: result!.user)
                self.isRegisterSuccess = true
            } else {
                print("Create user faild")
            }
        }
    }
    
    //    create user with email and password
//    func createUserWithEmailAndPassword(email: String, password: String) -> String {
//        do {
//            auth.createUser(withEmail: email, password: password) {
//                result, error in if let user = result?.user {
////                    add firebaseUser to cloud firestore
//                    FirebaseUserRepository().addFirebaseUser(user: user)
//                    let request = user.createProfileChangeRequest()
//                    request.commitChanges {
//                        error in
//                            if error == nil {
//                                user.sendEmailVerification() {
//                                    error in if error == nil {
//                                        self.isRegisterSuccess = true
//                                    }
//                                }
//                        }
//                    }
//                }
//            }
//        } catch {
//            let errorCode = AuthErrorCode.Code(rawValue: error._code)
//            switch errorCode {
//            case .networkError:
//                return AuthError.networkError.title
//            case .weakPassword:
//                return AuthError.weakPassword.title
//            case .emailAlreadyInUse:
//                return AuthError.emailAlreadyInUse.title
//            default:
//                return AuthError.unknown.title
//            }
//        }
//        return ""
//    }
    
    //    login with email and password
//    func signInWithEmailAndPassword(email: String, password: String) -> String? {
//        do {
//            try auth.signIn(withEmail: email, password: password)
//            return "Sign in"
//        } catch {
//            let errorCode = AuthErrorCode.Code(rawValue: error._code)
//            switch errorCode {
//            case .networkError:
//                return AuthError.networkError.title
//            case .weakPassword:
//                return AuthError.weakPassword.title
//            case .wrongPassword:
//                return AuthError.wrongPassword.title
//            case .userNotFound:
//                return AuthError.userNotFound.title
//            default:
//                return AuthError.unknown.title
//            }
//        }
//    }
    
    func signInWithEmailAndPassword(email: String, password: String) async throws -> String {
        do {
            try await auth.signIn(withEmail: email, password: password)
            return "Sign in"
        } catch let error as NSError {
            let errorCode = AuthErrorCode.Code(rawValue: error.code)
            switch errorCode {
            case .networkError:
                throw AuthError.networkError
            case .weakPassword:
                throw AuthError.weakPassword
            case .wrongPassword:
                throw AuthError.wrongPassword
            case .userNotFound:
                throw AuthError.userNotFound
            default:
                throw AuthError.unknown
            }
        }
    }

    
    //    sign out
    func signOut() -> String? {
        do {
            try auth.signOut()
            return "Sign out"
        } catch {
            let errorCode = AuthErrorCode.Code(rawValue: error._code)
            switch errorCode {
            case .networkError:
                return AuthError.networkError.title
            default:
                return AuthError.unknown.title
            }
        }
    }
    
    //    send password reset email
    func sendPasswordResetEmail(email: String) -> Void {
        auth.sendPasswordReset(withEmail: email) { error in
        }
    }
}

