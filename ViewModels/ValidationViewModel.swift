//
//  ValidationViewModel.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/06/22.
//

import Foundation
import Combine

class ValidationViewModel: ObservableObject {
    
    @Published var signUpEmail = ""
    @Published var signUpPassword = ""
    @Published var signUpRetypePassword = ""
    @Published var logInEmail = ""
    @Published var logInPassword = ""
    @Published var resetPasswordEmail = ""
    @Published var canSignUpSend = false
    @Published var canLogInSend = false
    @Published var canSendResetPasswordEmail = false
    @Published var invalidSignUpMailMessage = ""
    @Published var invalidLogInMailMessage = ""
    @Published var invalidResetPasswordMailMessage = ""
    @Published var invalidPasswordMessage = ""
    
    init() {
        
        //①登録できるかどうかの判定
        let signUpEmailValidation = $signUpEmail.map({ !$0.isEmpty && $0.isValidEmail }).eraseToAnyPublisher()
        let signUpPasswordValidation = $signUpPassword.map({ !$0.isEmpty }).eraseToAnyPublisher()
        let signUpRetypePasswordValidation = $signUpRetypePassword.map({ !$0.isEmpty }).eraseToAnyPublisher()
        let matchSignUpValidation = $signUpPassword.combineLatest($signUpRetypePassword).map({ $0 == $1 }).eraseToAnyPublisher()
        Publishers.CombineLatest4(signUpEmailValidation, signUpPasswordValidation, signUpRetypePasswordValidation, matchSignUpValidation)
            .map({ [$0.0, $0.1, $0.2, $0.3] })
            .map({ $0.allSatisfy{ $0 } })
            .assign(to: &$canSignUpSend)
        
        $signUpEmail.map({ $0.isEmpty || $0.isValidEmail ? "" : "入力されたメールアドレスは有効ではありません" }).assign(to: &$invalidSignUpMailMessage)
        
        $signUpPassword.combineLatest($signUpRetypePassword)
            .filter({ !$0.1.isEmpty && !$0.1.isEmpty })
            .map({ $0.0 == $0.1 ? "" : "パスワードが一致していません" })
            .assign(to: &$invalidPasswordMessage)
        
        let logInEmailValidation = $logInEmail.map({ !$0.isEmpty && $0.isValidEmail }).eraseToAnyPublisher()
        logInEmailValidation.assign(to: &$canLogInSend)
        
        $logInEmail.map({ $0.isEmpty || $0.isValidEmail ? "" : "入力されたメールアドレスは有効ではありません" }).assign(to: &$invalidLogInMailMessage)
        
        let resetPasswordEmailValidation = $resetPasswordEmail.map({ !$0.isEmpty && $0.isValidEmail }).eraseToAnyPublisher()
        resetPasswordEmailValidation.assign(to: &$canSendResetPasswordEmail)
        
        $resetPasswordEmail.map({ $0.isEmpty || $0.isValidEmail ? "" : "入力されたメールアドレスは有効ではありません" }).assign(to: &$invalidResetPasswordMailMessage)
    }
    
}

extension String {
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
     }
    
}
