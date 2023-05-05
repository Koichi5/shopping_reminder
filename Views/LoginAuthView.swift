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
                TextField("mail address", text: $email).padding().textFieldStyle(.roundedBorder)
                TextField("password", text: $password).padding().textFieldStyle(.roundedBorder)
                Button(action: {
//                    AuthViewModel().signInWithEmailAndPassword(email: email, password: password)
//                    {
//                        result, error in
//                        if let user = result?.user {
//                            Text(user.email ?? "")
//                        }
//                    }
                }) {
                    Text("ログイン")
                }.padding()
                NavigationLink(destination: PasswordResetView()) {
                    Text("パスワードリセット")
                }.padding(.bottom)
                NavigationLink(destination: EntryAuthView()) {
                    Text("未登録の方はこちら")
                }.padding(.bottom)
            }.navigationTitle("ログイン")
        }
    }
}

struct LoginAuthView_Previews: PreviewProvider {
    static var previews: some View {
        LoginAuthView()
    }
}
