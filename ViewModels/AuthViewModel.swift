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
    
    @Published var isRegisterSuccess: Bool = false {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    @Published var isGoogleSignInSuccess: Bool = false {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    static let shared = AuthViewModel()
    private var auth = Auth.auth()
    private var firebaseUserRepository = FirebaseUserRepository()
    
    enum SignInState {
        case signedIn
        case signedOut
    }
    
    @Published var state: SignInState = .signedOut
    
    func createUserWithEmailAndPassword(email: String, password: String) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if (result?.user != nil) {
                FirebaseUserRepository().addFirebaseUser(user: result!.user)
                self.isRegisterSuccess = true
            } else {
                print("Create user faild")
            }
        }
    }
    
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
    
    func signInWithGoogle() async -> Bool {
        print("sign in with google fired !")
      guard let clientID = FirebaseApp.app()?.options.clientID else {
        fatalError("No client ID found in Firebase configuration")
      }
      let config = GIDConfiguration(clientID: clientID)
      GIDSignIn.sharedInstance.configuration = config
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
                FirebaseUserRepository().addFirebaseUser(user: result.user)
                self.isGoogleSignInSuccess = true
                print("is google sign in success in func: \(isGoogleSignInSuccess)")
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
        print("sign out fired")
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
    
    func signInAnnonymously() async throws -> Void {
        do {
            try await auth.signInAnonymously()
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
            print("Error occured during deleting user")
          } else {
              self.firebaseUserRepository.deleteFirebaseUser(userUid: user!.uid)
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

