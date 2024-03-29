//
//  ErrorView.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/08/07.
//

import SwiftUI

struct ErrorView: View {
    var errorText: String
    var body: some View {
        Text(errorText)
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(errorText: "エラーメッセージ")
    }
}
