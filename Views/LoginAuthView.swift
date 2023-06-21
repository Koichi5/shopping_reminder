//
//  LoginAuthView.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/04.
//

import SwiftUI
import FirebaseAuth

struct LoginAuthView: View {
    @State var email: String = ""
    @State var password: String = ""
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
//                    .textFieldStyle(.roundedBorder)
                TextField("password", text: $password)
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
                        try await Auth.auth().signIn(withEmail: email, password: password){ result, error in
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
                }.padding()
                NavigationLink(destination: PasswordResetView()) {
                    Text("パスワードをお忘れの方")
                }.padding(.bottom)
                NavigationLink(destination: EntryAuthView()                .navigationBarBackButtonHidden(true)) {
                    Text("新規登録はこちら")
                }
                .padding(.bottom)
            }.padding()
            .navigationTitle("ログイン")
        }
    }
}

struct LoginAuthView_Previews: PreviewProvider {
    static var previews: some View {
        LoginAuthView()
    }
}
