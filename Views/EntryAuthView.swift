//
//  EntryAuthView.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/04.
//

import SwiftUI
import FirebaseAuth

struct EntryAuthView: View {
    @State var name:String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var isRegisterSuccess: Bool = false
    @State var isAlertShown: Bool = false
    @ObservedObject var authViewModel:AuthViewModel = AuthViewModel()
    var body: some View {
        NavigationView(content: {
            VStack {
                TextField("name", text: $name)
                    .padding(.vertical)
                    .padding(.leading)
                    .overlay(
                        RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0))
                            .stroke(Color.foreground, lineWidth: 1.0)
                    )
                    .padding(.bottom)
                TextField("email", text: $email)
                    .padding(.vertical)
                    .padding(.leading)
                    .overlay(
                        RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0))
                            .stroke(Color.foreground, lineWidth: 1.0)
                    )
                    .padding(.bottom)
                //                    .textFieldStyle(.roundedBorder)
                //                Text("password")
                SecureField("password", text: $password)
                    .padding(.vertical)
                    .padding(.leading)
                    .overlay(
                        RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0))
                            .stroke(Color.foreground, lineWidth: 1.0)
                    )
                    .padding(.bottom)
                //                    .textFieldStyle(.roundedBorder)
                Button(action: {
                    Auth.auth().createUser(withEmail: email, password: password) { result, error in
                        if (result?.user) != nil {
                            FirebaseUserRepository().addFirebaseUser(user: result!.user)
                            isRegisterSuccess = true
                        } else {
                            isAlertShown = true
                        }
                    }
                    Task{
                        try await ShoppingItemRepository().addUserSnapshotListener()
                    }
                }, label: {
                    Text("新規登録")
                })
                .padding(.bottom)
                NavigationLink(destination: LoginAuthView().navigationBarBackButtonHidden(true)) {
                    Text("アカウントをお持ちの方はこちら")
                }
                .padding(.bottom)
                GoogleSignInButton()
                    .padding(.bottom)
            }
            .padding()
            .fullScreenCover(isPresented: $isRegisterSuccess) {
                IntroView()
            }
            .alert(isPresented: $isAlertShown) {
                Alert(title: Text("登録に失敗しました。再度お試しください"))
            }
            .navigationTitle(Text("新規登録"))
        }
        )
    }
}

struct EntryAuthView_Previews: PreviewProvider {
    static var previews: some View {
        EntryAuthView()
    }
}
