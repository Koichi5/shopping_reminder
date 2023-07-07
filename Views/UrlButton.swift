//
//  UrlButton.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/13.
//

import SwiftUI

struct UrlButton: View {
    @ObservedObject var userDefaultsHelper = UserDefaultsHelper()
    let systemName: String
    let buttonText: String
    let sourceUrl: String
    var body: some View {
        HStack {
            Image(systemName: systemName)
            Spacer()
            Button(action: {
                if let url = URL(string: sourceUrl) {
                    UIApplication.shared.open(url, options: [.universalLinksOnly: false], completionHandler: { completed in
                        print(completed)
                    })
                }
            }) {
                Text(buttonText)
                    .lineLimit(1)
                    .foregroundColor(Color.black)
            }
        }
        .padding()
    }
}

struct UrlButton_Previews: PreviewProvider {
    static var previews: some View {
        UrlButton(systemName: "app.gift", buttonText: "URL", sourceUrl: "")
    }
}
