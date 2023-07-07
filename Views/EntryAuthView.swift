//
//  EntryAuthView.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/04.
//

import SwiftUI
import FirebaseAuth
import Foundation
import FirebaseCore
import GoogleSignIn

enum CustomAuthError:Error{
    case failed
    case overflow
}

struct EntryAuthView: View {
    enum Field: Hashable {
        case email
        case password
        case retypePassword
    }
    @FocusState private var focusedField: Field?
    @State var isRegisterSuccess: Bool = false
        @State var isGoogleSignInSuccess: Bool = false
    @State var isAlertShown: Bool = false
    @State var isTextfieldEditting : Bool = false
    @State private var isHidePassword: Bool = true
    @State private var isHideRetypePassword: Bool = true
    @ObservedObject var userDefaultsHelper = UserDefaultsHelper()
    @ObservedObject var authViewModel: AuthViewModel = AuthViewModel()
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
//                GoogleSignInButton()
                Button(action: {
                    Task {
                        do {
                            print("sign in with google fired !")
                          guard let clientID = FirebaseApp.app()?.options.clientID else {
                            fatalError("No client ID found in Firebase configuration")
                          }
                          let config = GIDConfiguration(clientID: clientID)
                          GIDSignIn.sharedInstance.configuration = config
                            guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                  let window = await windowScene.windows.first,
                                  let rootViewController = await window.rootViewController else {
                            print("There is no root view controller!")
                                throw CustomAuthError.failed
                          }
                            do {
                              let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)

                              let user = userAuthentication.user
                              guard let idToken = user.idToken else {
                                  print("error occured during google sign in")
                                  throw CustomAuthError.failed
                              }
                              let accessToken = user.accessToken
                              let credential = GoogleAuthProvider.credential(
                                withIDToken: idToken.tokenString,
                                accessToken: accessToken.tokenString
                              )

                              let result = try await Auth.auth().signIn(with: credential)
                              let firebaseUser = result.user
                                if (firebaseUser != nil) {
                                    FirebaseUserRepository().addFirebaseUser(user: result.user)
                                    isGoogleSignInSuccess = true
                                    print("is google sign in success in func: \(self.isGoogleSignInSuccess)")
                                }
                              print("User \(firebaseUser.uid) signed in with email \(firebaseUser.email ?? "unknown")")
                            }
                            catch {
                              print(error.localizedDescription)
                    //          self.errorMessage = error.localizedDescription
                            }
                        }
                    }
                }) {
                    HStack {
                        Spacer()
                        Image("google_logo")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Spacer()
                        Text("Google でサインイン")
                            .foregroundColor(Color.foreground)
                        Spacer()
                    }
                    .padding(.vertical, 15)
                    .overlay(
                        RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0))
                            .stroke(Color.foreground, lineWidth: 1.0)
                    )
                    .padding(.bottom)
                }
                    .frame(maxWidth: .infinity, minHeight: 48)
                AppleSignInButton()
                    .padding(.bottom)
                    .frame(maxWidth: .infinity, minHeight: 48, maxHeight: 65)
            }
            .padding()
//            .fullScreenCover(isPresented: self.$authViewModel.isRegisterSuccess) {
//                IntroView()
//            }
            .fullScreenCover(isPresented: $isRegisterSuccess) {
                IntroView()
            }
//            .fullScreenCover(isPresented: self.$authViewModel.isGoogleSignInSuccess) {
//                IntroView()
//            }
            .fullScreenCover(isPresented: $isGoogleSignInSuccess) {
                IntroView()
            }
            .alert(isPresented: $isAlertShown) {
                Alert(title: Text("登録に失敗しました。再度お試しください"))
            }
            .navigationTitle(Text("新規登録"))
            .navigationBarTitleDisplayMode(isTextfieldEditting ? .inline : .large)
            .contentShape(RoundedRectangle(cornerRadius: 0.0))
            .onTapGesture {
                UIApplication.shared.endEditing()
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                isTextfieldEditting = false
            }
        }
        )
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct EntryAuthView_Previews: PreviewProvider {
    static var previews: some View {
        EntryAuthView()
    }
}
