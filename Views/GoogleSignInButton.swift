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
    @ObservedObject var userDefaultsHelper = UserDefaultsHelper()
    var body: some View {
        Button(action: {
            Task {
                do {
                    try await AuthViewModel().signInWithGoogle()
                }
            }
        }) {
            HStack {
                Spacer()
                Image("google_logo")
                    .resizable()
                    .frame(width: 20, height: 20)
                Spacer()
                Text("Google でサインイン")
                    .foregroundColor(Color.foreground)
                Spacer()
            }
            .padding(.vertical, 15)
            .overlay(
                RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0))
                    .stroke(Color.foreground, lineWidth: 1.0)
            )
            .padding(.bottom)
        }
//        .preferredColorScheme(userDefaultsHelper.isDarkModeOn ? .dark : .light)

    }
}

struct GoogleSignInButton_Previews: PreviewProvider {
    static var previews: some View {
        GoogleSignInButton()
    }
}
