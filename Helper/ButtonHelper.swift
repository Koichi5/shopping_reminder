//
//  ButtonHelper.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/20.
//

import SwiftUI

struct ButtonHelper: View {
    @ObservedObject var userDefaultsHelper = UserDefaultsHelper()
    let buttonText: String
    let buttonAction: () -> Void
    let foregroundColor: Color
    let backgroundColor: Color
    let buttonTextIsBold: Font.Weight?
    let buttonWidth: CGFloat?
    let buttonHeight: CGFloat?
    let buttonTextFontSize: CGFloat?
    var body: some View {
        Button(action: {
            buttonAction()
        }) {
            Text(buttonText)
                .fontWeight(buttonTextIsBold ?? .bold)
                .font(.system(size: buttonTextFontSize ?? 20))
                .foregroundColor(foregroundColor)
                .frame(maxWidth: buttonWidth ?? .infinity,
                       minHeight: buttonHeight ?? 48)
                .background(backgroundColor.cornerRadius(10))
                .padding(.horizontal, 32)
        }
//        .preferredColorScheme(userDefaultsHelper.isDarkModeOn ? .dark : .light)
    }
    
//    func elevatedButton(buttonText: String, buttonAction: () -> Void) -> some View {
//        Button(action: {
//            buttonAction()
//        }) {
//            Text(buttonText)
//                .fontWeight(.bold)
//                .font(.system(size: 20))
//                .foregroundColor(Color.white)
//                .frame(maxWidth: .infinity, minHeight: 48)
//                .background(Color.red.cornerRadius(10))
//                .padding(.horizontal, 32)
//        }
//    }
}

//struct ButtonHelper_Previews: PreviewProvider {
//    static var previews: some View {
//        ButtonHelper()
//    }
//}
