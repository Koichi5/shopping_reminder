//
//  ValidationViewModel.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/06/22.
//

import Foundation
import Combine

class ValidationViewModel: ObservableObject {
    
    @Published var email = "" //メールアドレスの入力値を格納
    @Published var password = "" //パスワードの入力値を格納
    @Published var retypePassword = "" //パスワードの再入力値を格納
    
    @Published var canSend = false  //登録できるかどうかのフラグ
    @Published var invalidMailMessage = "" //無効なメールアドレスの時のエラー文言
    @Published var invalidPasswordMessage = "" //無効なパスワードの時のエラー文言
    
    init() {
        
        //①登録できるかどうかの判定
        let mailValidation = $email.map({ !$0.isEmpty && $0.isValidEmail }).eraseToAnyPublisher()
        let passValidation = $password.map({ !$0.isEmpty }).eraseToAnyPublisher()
        let retypeValidation = $retypePassword.map({ !$0.isEmpty }).eraseToAnyPublisher()
        let matchValidation = $password.combineLatest($retypePassword).map({ $0 == $1 }).eraseToAnyPublisher()
        Publishers.CombineLatest4(mailValidation, passValidation, retypeValidation, matchValidation)
            .map({ [$0.0, $0.1, $0.2, $0.3] }) //４つの条件(bool)を１つの配列にまとめます
            .map({ $0.allSatisfy{ $0 } }) //配列になった４つの条件(bool)が全てtrueの時に、結果がtrueとなります
            .assign(to: &$canSend) //結果をcanSendに格納します。
        
        //②メールアドレスのチェック
        $email.map({ $0.isEmpty || $0.isValidEmail ? "" : "enter valid mail address" }).assign(to: &$invalidMailMessage)
        
        //③パスワードのチェック
        $password.combineLatest($retypePassword)
            .filter({ !$0.1.isEmpty && !$0.1.isEmpty })
            .map({ $0.0 == $0.1 ? "" : "must match password" })
            .assign(to: &$invalidPasswordMessage)
                
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
