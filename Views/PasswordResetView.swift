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
    @ObservedObject var validationViewModel: ValidationViewModel = .init()
    var body: some View {
        NavigationView {
            VStack (alignment: .leading) {
                TextField.init("メールアドレス", text: self.$validationViewModel.resetPasswordEmail)
                    .padding(.vertical)
                    .padding(.leading)
                    .overlay(
                        RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0))
                            .stroke(Color.foreground, lineWidth: 1.0)
                    )
                    .padding(.bottom, !self.validationViewModel.invalidResetPasswordMailMessage.isEmpty ? 0 : 10)
                if !self.validationViewModel.invalidResetPasswordMailMessage.isEmpty {
                    Text(self.validationViewModel.invalidResetPasswordMailMessage)
                        .foregroundColor(.error)
                        .font(.caption)
            }
                Button(action: {
                    AuthViewModel().sendPasswordResetEmail(email: self.validationViewModel.resetPasswordEmail)
                }) {
                    Text("メール送信")
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .background(!self.validationViewModel.canSendResetPasswordEmail ? Color.gray.cornerRadius(10) : Color.blue.cornerRadius(10))
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
