//
//  ValidationViewModel.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/06/22.
//

import Foundation
import Combine

class ValidationViewModel: ObservableObject {
    
    @Published var signUpEmail = "" //メールアドレスの入力値を格納
    @Published var signUpPassword = "" //パスワードの入力値を格納
    @Published var signUpRetypePassword = "" //パスワードの再入力値を格納
    @Published var logInEmail = "" //メールアドレスの入力値を格納
    @Published var logInPassword = "" //パスワードの入力値を格納
    @Published var resetPasswordEmail = ""
    @Published var canSignUpSend = false  //登録できるかどうかのフラグ
    @Published var canLogInSend = false
    @Published var canSendResetPasswordEmail = false
    @Published var invalidSignUpMailMessage = "" //無効なメールアドレスの時のエラー文言
    @Published var invalidLogInMailMessage = "" //無効なメールアドレスの時のエラー文言
    @Published var invalidResetPasswordMailMessage = "" //無効なメールアドレスの時のエラー文言
    @Published var invalidPasswordMessage = "" //無効なパスワードの時のエラー文言
    
    init() {
        
        //①登録できるかどうかの判定
        let signUpEmailValidation = $signUpEmail.map({ !$0.isEmpty && $0.isValidEmail }).eraseToAnyPublisher()
        let signUpPasswordValidation = $signUpPassword.map({ !$0.isEmpty }).eraseToAnyPublisher()
        let signUpRetypePasswordValidation = $signUpRetypePassword.map({ !$0.isEmpty }).eraseToAnyPublisher()
        let matchSignUpValidation = $signUpPassword.combineLatest($signUpRetypePassword).map({ $0 == $1 }).eraseToAnyPublisher()
        Publishers.CombineLatest4(signUpEmailValidation, signUpPasswordValidation, signUpRetypePasswordValidation, matchSignUpValidation)
            .map({ [$0.0, $0.1, $0.2, $0.3] }) //４つの条件(bool)を１つの配列にまとめます
            .map({ $0.allSatisfy{ $0 } }) //配列になった４つの条件(bool)が全てtrueの時に、結果がtrueとなります
            .assign(to: &$canSignUpSend) //結果をcanSendに格納します。
        
        //②メールアドレスのチェック
        $signUpEmail.map({ $0.isEmpty || $0.isValidEmail ? "" : "enter valid mail address" }).assign(to: &$invalidSignUpMailMessage)
        
        //③パスワードのチェック
        $signUpPassword.combineLatest($signUpRetypePassword)
            .filter({ !$0.1.isEmpty && !$0.1.isEmpty })
            .map({ $0.0 == $0.1 ? "" : "must match password" })
            .assign(to: &$invalidPasswordMessage)
        
        //①登録できるかどうかの判定
        let logInEmailValidation = $logInEmail.map({ !$0.isEmpty && $0.isValidEmail }).eraseToAnyPublisher()
        logInEmailValidation.assign(to: &$canLogInSend)
        
        //②メールアドレスのチェック
        $logInEmail.map({ $0.isEmpty || $0.isValidEmail ? "" : "enter valid mail address" }).assign(to: &$invalidLogInMailMessage)
        
        //①登録できるかどうかの判定
        let resetPasswordEmailValidation = $resetPasswordEmail.map({ !$0.isEmpty && $0.isValidEmail }).eraseToAnyPublisher()
        resetPasswordEmailValidation.assign(to: &$canSendResetPasswordEmail)
        
        //②メールアドレスのチェック
        $resetPasswordEmail.map({ $0.isEmpty || $0.isValidEmail ? "" : "enter valid mail address" }).assign(to: &$invalidResetPasswordMailMessage)
    }
    
}

extension String {
    //メールアドレスの形式になっているかどうかの判定
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
     }
    
}
