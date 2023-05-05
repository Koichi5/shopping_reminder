//
//  PasswordResetView.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/04.
//

import SwiftUI
import FirebaseAuth

struct PasswordResetView: View {
    @State var email: String = ""
    var body: some View {
        VStack {
            TextField("mail address", text: $email).padding().textFieldStyle(.roundedBorder)
            Button(action: {
                AuthViewModel().sendPasswordResetEmail(email: email)
            }) {
                Text("メール送信")
            }
        }
    }
}

struct PasswordResetView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordResetView()
    }
}
