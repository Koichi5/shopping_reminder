//
//  Color.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/05.
//

import UIKit
import SwiftUI
import Foundation

//extension UIColor {
//    static let navigationBarTint = UIColor(named: "NavigationBarTint")!
//    static let navigationBarTitle = UIColor(named: "NavigationBarTitle")!
//}

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

//extension Color: Codable {
//  init(hex: String) {
//    let rgba = hex.toRGBA()
//
//    self.init(.sRGB,
//              red: Double(rgba.r),
//              green: Double(rgba.g),
//              blue: Double(rgba.b),
//              opacity: Double(rgba.alpha))
//  }
//
//  public init(from decoder: Decoder) throws {
//    let container = try decoder.singleValueContainer()
//    let hex = try container.decode(String.self)
//
//    self.init(hex: hex)
//  }
//
//  public func encode(to encoder: Encoder) throws {
//    var container = encoder.singleValueContainer()
//    try container.encode(toHex)
//  }
//
//  var toHex: String? {
//    return toHex()
//  }
//
//  func toHex(alpha: Bool = false) -> String? {
//    guard let components = cgColor?.components, components.count >= 3 else {
//      return nil
//    }
//
//    let r = Float(components[0])
//    let g = Float(components[1])
//    let b = Float(components[2])
//    var a = Float(1.0)
//
//    if components.count >= 4 {
//      a = Float(components[3])
//    }
//
//    if alpha {
//      return String(format: "%02lX%02lX%02lX%02lX",
//                    lroundf(r * 255),
//                    lroundf(g * 255),
//                    lroundf(b * 255),
//                    lroundf(a * 255))
//    }
//    else {
//      return String(format: "%02lX%02lX%02lX",
//                    lroundf(r * 255),
//                    lroundf(g * 255),
//                    lroundf(b * 255))
//    }
//  }
//}
//
//extension String {
//  func toRGBA() -> (r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat) {
//    var hexSanitized = self.trimmingCharacters(in: .whitespacesAndNewlines)
//    hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
//
//    var rgb: UInt64 = 0
//
//    var r: CGFloat = 0.0
//    var g: CGFloat = 0.0
//    var b: CGFloat = 0.0
//    var a: CGFloat = 1.0
//
//    let length = hexSanitized.count
//
//    Scanner(string: hexSanitized).scanHexInt64(&rgb)
//
//    if length == 6 {
//      r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
//      g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
//      b = CGFloat(rgb & 0x0000FF) / 255.0
//    }
//    else if length == 8 {
//      r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
//      g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
//      b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
//      a = CGFloat(rgb & 0x000000FF) / 255.0
//    }
//
//    return (r, g, b, a)
//  }
//}
    
//    init(hex: String) {
//       let rgba = hex.toRGBA()
//
//       self.init(.sRGB,
//                 red: Double(rgba.r),
//                 green: Double(rgba.g),
//                 blue: Double(rgba.b),
//                 opacity: Double(rgba.alpha))
//       }
//
//       //... (code for translating between hex and RGBA omitted for brevity)
////    static let button = Color("Button")
////    static let buttonLabel = Color("ButtonLabel")
////    static let redOrGreen = Color("RedOrGreen")
////    static let navigationBarTitle = Color(UIColor.navigationBarTitle)
//}
//
//extension Color: Codable {
//
//  public init(from decoder: Decoder) throws {
//    let container = try decoder.singleValueContainer()
//    let hex = try container.decode(String.self)
//
//    self.init(hex: hex)
//  }
//
//  public func encode(to encoder: Encoder) throws {
//    var container = encoder.singleValueContainer()
//    try container.encode(toHex)
//  }
//
//}
