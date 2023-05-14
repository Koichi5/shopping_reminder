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
    static let shared = AuthViewModel()
    private var auth = Auth.auth()
    
    enum SignInState {
        case signedIn
        case signedOut
    }
    
    @Published var state: SignInState = .signedOut
    
    private func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
      // 1
      if let error = error {
        print(error.localizedDescription)
        return
      }
      
      // 2
//      guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }
      
        guard let idToken = user?.idToken else { return }
        guard let accessToken = user?.accessToken else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
      
      // 3
      Auth.auth().signIn(with: credential) { [unowned self] (_, error) in
        if let error = error {
          print(error.localizedDescription)
        } else {
          self.state = .signedIn
        }
      }
    }
    
//    func signInWithGoogle() {
//        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
//          GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
////              authenticateUser(for: user, with: error)
//          }
//        } else {
//          // 2
//          guard let clientID = FirebaseApp.app()?.options.clientID else { return }
//
//          // 3
//          let configuration = GIDConfiguration(clientID: clientID)
//
//          // 4
//          guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
//          guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
//
//          // 5
//          GIDSignIn.sharedInstance.signIn(with: configuration, presenting: rootViewController) { [unowned self] user, error in
////            authenticateUser(for: user, with: error)
//          }
//        }
//    }
    
    func signInWithGoogle() async -> Bool {
      guard let clientID = FirebaseApp.app()?.options.clientID else {
        fatalError("No client ID found in Firebase configuration")
      }
      let config = GIDConfiguration(clientID: clientID)
      GIDSignIn.sharedInstance.configuration = config
//
//        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
//            guard error == nil else {
//        }
//
//            guard let user = result?.user,
//                  let idToken = user.idToken?.tokenString
//            else {}
//
//            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
//
//            Auth.auth().signIn(with: credential) { result, error in}
            
            
        
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
//              throw AuthenticationError.tokenError(message: "ID token missing")
              return false
          }
          let accessToken = user.accessToken

          let credential = GoogleAuthProvider.credential(
            withIDToken: idToken.tokenString,
            accessToken: accessToken.tokenString
          )

          let result = try await Auth.auth().signIn(with: credential)
          let firebaseUser = result.user
            if (firebaseUser != nil) {
                isRegisterSuccess = true
            }
          print("User \(firebaseUser.uid) signed in with email \(firebaseUser.email ?? "unknown")")
          return true
        }
        catch {
          print(error.localizedDescription)
//          self.errorMessage = error.localizedDescription
          return false
        }
    }
    
    func signOut() {
      // 1
      GIDSignIn.sharedInstance.signOut()
      
      do {
        // 2
        try Auth.auth().signOut()
        
        state = .signedOut
      } catch {
        print(error.localizedDescription)
      }
    }
    
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

