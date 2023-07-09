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
    @State var isLogInSucceeded: Bool = false
    @State var isShowLogInFailAlert: Bool = false
    var body: some View {
        NavigationView {
            VStack (alignment: .leading){
                TextField.init("メールアドレス", text: self.$validationViewModel.logInEmail)
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
                SecureField.init("パスワード", text: $password)
                    .padding(.vertical)
                    .padding(.leading)
                    .overlay(
                        RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0))
                            .stroke(Color.foreground, lineWidth: 1.0)
                    )
                    .padding(.bottom)
                Button(action: {
                    Task {
                        try await Auth.auth().signIn(withEmail: self.validationViewModel.logInEmail, password: password){ result, error in
                            if let user = result?.user {
                                print("logged in with user -- \(result?.user)")
                                isLogInSucceeded = true
                            } else {
                                isShowLogInFailAlert = true
                            }
                        }
                    }
                }) {
                    Text("ログイン")
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .background(!self.validationViewModel.canLogInSend ? Color.gray.cornerRadius(10) : Color.blue.cornerRadius(10))
                }
                .disabled(!self.validationViewModel.canLogInSend)
                .padding(.bottom)
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
            .fullScreenCover(isPresented: $isLogInSucceeded) {
                HomeView()
            }
            .alert(isPresented: $isShowLogInFailAlert){
                Alert(
                    title: Text("ログインに失敗しました"),
                    message: Text("メールアドレスまたはパスワードが誤っています"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct LoginAuthView_Previews: PreviewProvider {
    static var previews: some View {
        LoginAuthView()
    }
}
