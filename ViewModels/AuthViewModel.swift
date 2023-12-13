//
//  AuthViewModel.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/03.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

class AuthViewModel: ObservableObject {
    @Published var isRegisterSuccess: Bool = false
    @Published var isLoginSuccess: Bool = false
    @Published var isSignedOut: Bool = false
    static let shared = AuthViewModel()
    private var auth = Auth.auth()
    private var firebaseUserRepository = FirebaseUserRepository()
    func createUserWithEmailAndPassword(email: String, password: String) {
        auth.createUser(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                if (result?.user != nil) {
                    self.firebaseUserRepository.addFirebaseUser()
                    self.isRegisterSuccess = true
                } else {
                    print("Create user faild")
                }
            }
        }
    }
    
    func signInWithGoogle() async -> Bool {
        print("sign in with google fired !")
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("No client ID found in Firebase configuration")
        }
        let config = GIDConfiguration(clientID: clientID)
        DispatchQueue.main.async {
            GIDSignIn.sharedInstance.configuration = config
        }
        guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = await windowScene.windows.first,
              let rootViewController = await window.rootViewController else {
            print("There is no root view controller!")
            return false
        }
        
        do {
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            
            let user = userAuthentication.user
            guard let idToken = user.idToken else {
                print("error occured during google sign in")
                return false
            }
            let accessToken = user.accessToken
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken.tokenString,
                accessToken: accessToken.tokenString
            )
            
            let result = try await Auth.auth().signIn(with: credential)       
            DispatchQueue.main.async {
                if let isNewUser = result.additionalUserInfo?.isNewUser, isNewUser {
                    print("This is a new user.")
                    self.firebaseUserRepository.addFirebaseUser()
                    self.isRegisterSuccess = true
                } else {
                    print("This is an existing user")
                    self.isLoginSuccess = true
                }
            }
            return true
        }
        catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func signOut() {
        print("sign out fired")
        // 1
        GIDSignIn.sharedInstance.signOut()
        
        do {
            // 2
            try Auth.auth().signOut()
            
            self.isSignedOut = true
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func signInWithEmailAndPassword(email: String, password: String) async throws -> String {
        do {
            try await auth.signIn(withEmail: email, password: password)
            DispatchQueue.main.async {
                self.isLoginSuccess = true
            }
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
    
    func signInAnnonymously() async throws -> Void {
        do {
            try await auth.signInAnonymously()
            firebaseUserRepository.addFirebaseUser()
            DispatchQueue.main.async {
                self.isRegisterSuccess = true
            }
        } catch let error as NSError {
            let errorCode = AuthErrorCode.Code(rawValue: error.code)
            switch errorCode {
            case .networkError:
                throw AuthError.networkError
            default:
                throw AuthError.unknown
            }
        }
    }
    
    func signOut() -> String? {
        do {
            try auth.signOut()
            DispatchQueue.main.async {
                self.isSignedOut = true
            }
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
    
    func deleteUser() {
        let user = Auth.auth().currentUser
        
        user?.delete { error in
            if let error = error {
                print("Error occured during deleting user: \(error)")
            } else {
                self.firebaseUserRepository.deleteFirebaseUser(userUid: user!.uid)
                DispatchQueue.main.async {
                    self.isSignedOut = true
                }
                print("Accounted deleted")
            }
        }
    }
    
    //    send password reset email
    func sendPasswordResetEmail(email: String) -> Void {
        auth.sendPasswordReset(withEmail: email) { error in
        }
    }
}

