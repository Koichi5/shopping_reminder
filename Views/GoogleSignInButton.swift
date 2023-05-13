//
//  GoogleSignInButton.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/13.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

struct GoogleSignInButton: View {
    var body: some View {
        Button(action: {
            Task {
                do {
                    try await AuthViewModel().signInWithGoogle()
                }
            }
        }) {
            Text("Google でサインイン")
        }
    }
}

struct GoogleSignInButton_Previews: PreviewProvider {
    static var previews: some View {
        GoogleSignInButton()
    }
}
