//
//  IntroData.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/06/21.
//

import Foundation
import UIKit
import SwiftUI

struct PageData {
    let title: String
    let header: String
    let content: String
    let imageName: String
    let color: Color
    let textColor: Color
}

struct IntroPageData {
    static let pages: [PageData] = [
        PageData(
            title: "買い忘れそうな\nアイテムを追加しよう",
            header: "Step 1",
            content: "日用品から自動車の部品まで\n何でも登録しよう！",
            imageName: "first_tutorial_lottie",
            color: Color(hex: "F38181"),
            textColor: Color(hex: "4A4A4A")),
        PageData(
            title: "通知を待とう",
            header: "Step 2",
            content: "プッシュ通知を設定すると \n より忘れにくくなります！",
            imageName: "second_tutorial_lottie",
            color: Color(hex: "FCE38A"),
            textColor: Color(hex: "4A4A4A")),
        PageData(
            title: "リンクでお買い物を便利に",
            header: "Step 3",
            content: "よく買い物をするリンク先を\n登録してより効率的に買い物を",
            imageName: "third_tutorial_lottie",
            color: Color(hex: "95E1D3"),
            textColor: Color(hex: "4A4A4A")),
    ]
}

/// Color converter from hex string to SwiftUI's Color
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(red: Double(r) / 0xff, green: Double(g) / 0xff, blue: Double(b) / 0xff)
    }
}
