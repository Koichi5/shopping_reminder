//
//  AuthErrorModel.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/03.
//

import Foundation

public enum AuthError: Error {
    case networkError
    case weakPassword
    case wrongPassword
    case userNotFound
    case invalidEmail
    case emailAlreadyInUse
    case unknown
    
    //エラーによって表示する文字を定義
    var title: String {
        switch self {
        case .networkError:
            return "通信エラーです。"
        case .weakPassword:
            return "パスワードが脆弱です。"
        case .wrongPassword:
            return "メールアドレス、もしくはパスワードが違います。"
        case .userNotFound:
            return "アカウントがありません。"
        case .invalidEmail:
            return "正しくないメールアドレスの形式です。"
        case .emailAlreadyInUse:
            return "既に登録されているメールアドレスです。"
        case .unknown:
            return "エラーが起きました。"
        }
    }
}
