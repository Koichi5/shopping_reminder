//
//  AppleSignInButton.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/06/25.
//

import SwiftUI
import AuthenticationServices

struct AppleSignInButton: View {
    @State var isShowAlert: Bool = false
    @State var alertMessage: String = ""
    @ObservedObject var userDefaultsHelper = UserDefaultsHelper()
    @Environment(\.colorScheme) var colorScheme

    var isDarkMode: Bool {
        colorScheme == .dark
    }

    var body: some View {
        VStack {
            SignInWithAppleButton(.signUp) { request in
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { authResults in
                switch authResults {
                case .success(_): break
                case .failure(let error):
                    self.alertMessage = error.localizedDescription
                    self.isShowAlert.toggle()
                }
            }
            .signInWithAppleButtonStyle(isDarkMode ? .white : .black)
        }
        .alert(isPresented: $isShowAlert) {
            Alert(
                title: Text("Error"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct AppleSignInButton_Previews: PreviewProvider {
    static var previews: some View {
        AppleSignInButton()
    }
}
