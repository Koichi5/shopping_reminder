//
//  IntroItemView.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/12.
//

import SwiftUI

struct IntroItemView: View {
    let systemName: String
    let title: String
    let message: String
    var body: some View {
        HStack {
            Spacer()
            Image(systemName: systemName)
            Spacer()
            VStack (alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(message)
                    .font(.caption).foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
    }
}

struct IntroItemView_Previews: PreviewProvider {
    static var previews: some View {
        IntroItemView(
            systemName: "person", title: "Register", message: "You can register your shopping item"
        )
    }
}
