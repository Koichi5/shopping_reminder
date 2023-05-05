//
//  AuthErrorModel.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/03.
//

import Foundation

public enum AuthError: Error {
    case networkError
    // パスワードが条件より脆弱であることを示します。
    case weakPassword
    // ユーザーが間違ったパスワードでログインしようとしたことを示します。
    case wrongPassword
    // ユーザーのアカウントが無効になっていることを示します。
    case userNotFound
    // メールアドレスの形式が正しくないことを示します。
    case invalidEmail
    // 既に登録されているメールアドレス
    case emailAlreadyInUse
    // 不明なエラー
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
