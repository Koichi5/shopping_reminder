//
//  LoginAuthView.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/04.
//

import SwiftUI
import FirebaseAuth

struct LoginAuthView: View {
    @ObservedObject var userDefaultsHelper = UserDefaultsHelper()
    @ObservedObject var validationViewModel: ValidationViewModel = .init()
    @State var password: String = ""
    var body: some View {
        NavigationView {
            VStack (alignment: .leading){
                TextField.init("mail address", text: self.$validationViewModel.logInEmail)
                    .padding(.vertical)
                    .padding(.leading)
                    .overlay(
                        RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0))
                            .stroke(Color.foreground, lineWidth: 1.0)
                    )
                    .padding(.bottom,                    !self.validationViewModel.invalidLogInMailMessage.isEmpty ? 0 : 10)
                if !self.validationViewModel.invalidLogInMailMessage.isEmpty {
                    Text(self.validationViewModel.invalidLogInMailMessage)
                        .foregroundColor(.error)
                        .font(.caption)
            }
//                    .textFieldStyle(.roundedBorder)
                SecureField.init("password", text: $password)
                    .padding(.vertical)
                    .padding(.leading)
                    .overlay(
                        RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0))
                            .stroke(Color.foreground, lineWidth: 1.0)
                    )
                    .padding(.bottom)
//                    .textFieldStyle(.roundedBorder)
                Button(action: {
                    Task {
                        try await Auth.auth().signIn(withEmail: self.validationViewModel.logInEmail, password: password){ result, error in
                            if let user = result?.user {
                                print("logged in with user -- \(result?.user)")
                            } else {
                                print("login failed")
                            }
                        }
                    }
//                    { result, error in
//                        if let user = result?.user {
//                            Text(user.email ?? "")
//                        }
//                    }
                }) {
                    Text("ログイン")
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .background(!self.validationViewModel.canLogInSend ? Color.gray.cornerRadius(10) : Color.blue.cornerRadius(10))
                }
                .disabled(!self.validationViewModel.canLogInSend)
                NavigationLink(destination: PasswordResetView()) {
                    Text("パスワードをお忘れの方")
                        .font(.roundedBoldFont())
                }
                .padding(.bottom)
                .frame(maxWidth: .infinity, minHeight: 48)
                NavigationLink(destination: EntryAuthView()                .navigationBarBackButtonHidden(true)) {
                    Text("新規登録はこちら")
                        .font(.roundedBoldFont())
                }
                .padding(.bottom)
                .frame(maxWidth: .infinity, minHeight: 48)
            }
            .padding()
            .navigationTitle("ログイン")
        }
//        .preferredColorScheme(userDefaultsHelper.isDarkModeOn ? .dark : .light)
    }
}

struct LoginAuthView_Previews: PreviewProvider {
    static var previews: some View {
        LoginAuthView()
    }
}
