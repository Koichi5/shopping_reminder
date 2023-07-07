//
//  Color.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/05.
//

import UIKit
import SwiftUI
import Foundation

extension Font {
    static func roundedFont() -> Font {
        return Font.system(size: 18, design: .rounded)
    }
    static func roundedBoldFont() -> Font {
        return Font.system(size: 18, weight: .bold, design: .rounded)
    }
}

extension Color {
    static let background = Color("Background")
    static let foreground = Color("Foreground")
    static let itemCard = Color("ItemCard")
    static let error = Color("Error")
//    static let errorContainer = Color("ErrorContainer")
//    static let primary = Color("Primary")
//    static let primaryContainer = Color("PrimaryContainer")
//    static let secondary = Color("Secondary")
//    static let secondaryContainer = Color("SecondaryContainer")
//    static let tertiary = Color("Tertiary")
//    static let tertiaryContainer = Color("TertiaryContainer")
//    static let onErrorContainer = Color("OnErrorContainer")
//    static let onPrimaryContainer = Color("OnPrimaryContainer")
//    static let onSecondaryContainer = Color("OnSecondaryContainer")
//    static let onTertiaryContainer = Color("OnTertiaryContainer")
}

var colorList: [Color] = [
    Color.red,
    Color.orange,
    Color.yellow,
    Color.green,
    Color.teal,
    Color.blue,
    Color.purple,
    Color.pink,
    Color.gray,
    Color.black
]
