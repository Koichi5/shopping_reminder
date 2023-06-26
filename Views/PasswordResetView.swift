//
//  PasswordResetView.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/04.
//

import SwiftUI
import FirebaseAuth

struct PasswordResetView: View {
    @ObservedObject var userDefaultsHelper = UserDefaultsHelper()
    @State var email: String = ""
    var body: some View {
        NavigationView {
            VStack {
                TextField("mail address", text: $email)
                    .padding(.vertical)
                    .padding(.leading)
                    .overlay(
                        RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0))
                            .stroke(Color.foreground, lineWidth: 1.0)
                    )
                    .padding(.bottom)
                Button(action: {
                    AuthViewModel().sendPasswordResetEmail(email: email)
                }) {
                    Text("メール送信")
                }
            }
            .padding()
        }
        .navigationTitle(Text("パスワード再設定"))
//        .preferredColorScheme(userDefaultsHelper.isDarkModeOn ? .dark : .light)
    }
}

struct PasswordResetView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordResetView()
    }
}
