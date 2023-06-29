//
//  EntryAuthView.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/04.
//

import SwiftUI
import FirebaseAuth

struct EntryAuthView: View {
    enum Field: Hashable {
        case email
        case password
        case retypePassword
    }
    @FocusState private var focusedField: Field?
    @State var isRegisterSuccess: Bool = false
    //    @State var isGoogleSignInSuccess: Bool = false
    @State var isAlertShown: Bool = false
    @State var isTextfieldEditting : Bool = false
    @State private var isHidePassword: Bool = true
    @State private var isHideRetypePassword: Bool = true
    //    @State var isLoading: Bool = false
    @ObservedObject var userDefaultsHelper = UserDefaultsHelper()
    @ObservedObject var authViewModel = AuthViewModel()
    @ObservedObject var validationViewModel: ValidationViewModel = .init()
    var body: some View {
        NavigationView(content: {
            VStack (alignment: .leading){
                //                Group {
                TextField.init(
                    "メールアドレス",
                    text: self.$validationViewModel.signUpEmail
                )
                .focused($focusedField, equals: .email)
                .onChange(of: focusedField, perform: { newValue in
                    isTextfieldEditting = true
                })
                .padding(.vertical)
                .padding(.leading)
                .overlay(
                    RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0))
                        .stroke(Color.foreground, lineWidth: 1.0)
                )
                .padding(.bottom, !self.validationViewModel.invalidSignUpMailMessage.isEmpty ? 0 : 10)
                if !self.validationViewModel.invalidSignUpMailMessage.isEmpty {
                    Text(self.validationViewModel.invalidSignUpMailMessage)
                        .foregroundColor(.error)
                        .font(.caption)
                }
                ZStack (alignment: .trailing) {
                        if isHidePassword {
                            SecureField.init("パスワード", text: self.$validationViewModel.signUpPassword)
                                .focused($focusedField, equals: .password)
                                .onChange(of: focusedField, perform: { newValue in
                                    isTextfieldEditting = true
                                })
                                .textContentType(.newPassword)
                                .padding(.vertical)
                                .padding(.leading)
                                .overlay(
                                    RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0))
                                        .stroke(Color.foreground, lineWidth: 1.0)
                                )
                        } else {
                            TextField.init("パスワード", text: self.$validationViewModel.signUpPassword)
                                .focused($focusedField, equals: .password)
                                .onChange(of: focusedField, perform: { newValue in
                                    isTextfieldEditting = true
                                })
                                .textContentType(.newPassword)
                                .padding(.vertical)
                                .padding(.leading)
                                .overlay(
                                    RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0))
                                        .stroke(Color.foreground, lineWidth: 1.0)
                                )
                        }
                        Button(action: {
                            isHidePassword.toggle()
                        }) {
                            Image(systemName: self.isHidePassword ? "eye.slash" : "eye")
                                .foregroundColor(Color.foreground)
                        }.padding()
                }
                .padding(.bottom, 10)
                
                ZStack (alignment: .trailing) {
                        if isHideRetypePassword {
                            SecureField.init("パスワード（確認）", text: self.$validationViewModel.signUpRetypePassword)
                                .focused($focusedField, equals: .retypePassword)
                                .onChange(of: focusedField, perform: { newValue in
                                    isTextfieldEditting = true
                                })
                                .textContentType(.newPassword)
                                .padding(.vertical)
                                .padding(.leading)
                                .overlay(
                                    RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0))
                                        .stroke(Color.foreground, lineWidth: 1.0)
                                )
                        } else {
                            TextField.init("パスワード（確認）", text: self.$validationViewModel.signUpRetypePassword)
                                .focused($focusedField, equals: .retypePassword)
                                .onChange(of: focusedField, perform: { newValue in
                                    isTextfieldEditting = true
                                })
                                .textContentType(.newPassword)
                                .padding(.vertical)
                                .padding(.leading)
                                .overlay(
                                    RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0))
                                        .stroke(Color.foreground, lineWidth: 1.0)
                                )
                        }
                        Button(action: {
                            isHideRetypePassword.toggle()
                        }) {
                            Image(systemName: self.isHideRetypePassword ? "eye.slash" : "eye")
                                .foregroundColor(Color.foreground)
                        }.padding()
                }
                .padding(.bottom, !self.validationViewModel.invalidPasswordMessage.isEmpty ? 0 : 10)
                
                if !self.validationViewModel.invalidPasswordMessage.isEmpty {
                    Text(self.validationViewModel.invalidPasswordMessage)
                        .foregroundColor(.error)
                        .font(.caption)
                }
                Button(action: {
                    Auth.auth().createUser(
                        withEmail: self.validationViewModel.signUpEmail,
                        password: self.validationViewModel.signUpPassword) { result, error in
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
                        ShoppingItemRepository().removeCurrentSnapshotListener()
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
                        .background(!self.validationViewModel.canSignUpSend ? Color.gray.cornerRadius(10) : Color.blue.cornerRadius(10))
                    //                    }
                }
                .disabled(!self.validationViewModel.canSignUpSend)
                .padding(.bottom)
                NavigationLink(destination: LoginAuthView().navigationBarBackButtonHidden(true)) {
                    Text("アカウントをお持ちの方はこちら")
                        .font(.roundedBoldFont())
                }
                .padding(.bottom)
                .frame(maxWidth: .infinity, minHeight: 48)
                Divider()
                    .background(Color.foreground)
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
            .fullScreenCover(isPresented: $authViewModel.isGoogleSignInSuccess) {
                IntroView()
            }
            .alert(isPresented: $isAlertShown) {
                Alert(title: Text("登録に失敗しました。再度お試しください"))
            }
            .navigationTitle(Text("新規登録"))
            .navigationBarTitleDisplayMode(isTextfieldEditting ? .inline : .large)
            //            .preferredColorScheme(userDefaultsHelper.isDarkModeOn ? .dark : .light)
            
        }
        )
    }
}

struct EntryAuthView_Previews: PreviewProvider {
    static var previews: some View {
        EntryAuthView()
    }
}
