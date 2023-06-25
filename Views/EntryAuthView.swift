//
//  EntryAuthView.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/04.
//

import SwiftUI
import FirebaseAuth

struct EntryAuthView: View {
    @State var isRegisterSuccess: Bool = false
    @State var isAlertShown: Bool = false
//    @State var isLoading: Bool = false
    @ObservedObject var authViewModel: AuthViewModel = AuthViewModel()
    @ObservedObject var validationViewModel: ValidationViewModel = .init()
    var body: some View {
        NavigationView(content: {
            VStack (alignment: .leading){
//                Group {
                    TextField.init("email", text: self.$validationViewModel.email)
                        .padding(.vertical)
                        .padding(.leading)
                        .overlay(
                            RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0))
                                .stroke(Color.foreground, lineWidth: 1.0)
                        )
                        .padding(.bottom, !self.validationViewModel.invalidMailMessage.isEmpty ? 0 : 10)
                    if !self.validationViewModel.invalidMailMessage.isEmpty {
                        Text(self.validationViewModel.invalidMailMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                }
                    SecureField.init("password", text: self.$validationViewModel.password)
                        .textContentType(.newPassword)
                        .padding(.vertical)
                        .padding(.leading)
                        .overlay(
                            RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0))
                                .stroke(Color.foreground, lineWidth: 1.0)
                        )
                        .padding(.bottom)
                    
                    SecureField.init("retype - password", text: self.$validationViewModel.retypePassword)
                        .textContentType(.newPassword)
                        .padding(.vertical)
                        .padding(.leading)
                        .overlay(
                            RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0))
                                .stroke(Color.foreground, lineWidth: 1.0)
                        )
                        .padding(.bottom, !self.validationViewModel.invalidPasswordMessage.isEmpty ? 0 : 10)
                    
                    if !self.validationViewModel.invalidPasswordMessage.isEmpty {
                        Text(self.validationViewModel.invalidPasswordMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                Button(action: {
                    Auth.auth().createUser(
                        withEmail: self.validationViewModel.email,
                        password: self.validationViewModel.password) { result, error in
//                        isLoading = true
                        if (result?.user) != nil {
                            FirebaseUserRepository().addFirebaseUser(user: result!.user)
                            isRegisterSuccess = true
//                            isLoading = false
                        } else {
                            isAlertShown = true
//                            isLoading = false
                        }
                    }
                    Task{
                        try await ShoppingItemRepository().addUserSnapshotListener()
                    }
                }) {
//                    if (
//                        isLoading
//                    )
//                    { LottieView(fileName: "loading_lottie.json")
//                    } else {
                        Text("新規登録")
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .frame(maxWidth: .infinity, minHeight: 48)
                            .background(!self.validationViewModel.canSend ? Color.gray.cornerRadius(10) : Color.blue.cornerRadius(10))
//                    }
                }
                .disabled(!self.validationViewModel.canSend)
                .padding(.bottom)
                NavigationLink(destination: LoginAuthView().navigationBarBackButtonHidden(true)) {
                    Text("アカウントをお持ちの方はこちら")
                }
                .padding(.bottom)
                .frame(maxWidth: .infinity, minHeight: 48)
                Divider()
                    .padding(.bottom)
                GoogleSignInButton()
                    .frame(maxWidth: .infinity, minHeight: 48)
                AppleSignInButton()
                    .padding(.bottom)
                    .frame(maxWidth: .infinity, minHeight: 48, maxHeight: 65)
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
