//
//  Category.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/04.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift

struct Category: Identifiable, Codable {
    
    @DocumentID var id: String?
    var name: String
    var color: CategoryColor
    var items: [ShoppingItem]
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case color
        case items
    }
    
    init(
        name: String, color: CategoryColor,
         items: [ShoppingItem] = []) {
        self.name = name
        self.color = color
        self.items = items
    }
}

enum CategoryColor: Int, Codable, CaseIterable {
    case red
    case orange
    case yellow
    case green
    case tealBlue
    case blue
    case purple
    case pink
    case gray
    case black
    
    var colorName: String {
        switch self {
        case .red:
            return "Red"
        case .orange:
            return "Orange"
        case .yellow:
            return "Yellow"
        case .green:
            return "Green"
        case .tealBlue:
            return "Teal Blue"
        case .blue:
            return "Blue"
        case .purple:
            return "Purple"
        case .pink:
            return "Pink"
        case .gray:
            return "Gray"
        case .black:
            return "Black"
        }
    }
    
    var colouNum: Int{
        switch self {
        case .red:
            return 1
        case .orange:
            return 2
        case .yellow:
            return 3
        case .green:
            return 4
        case .tealBlue:
            return 5
        case .blue:
            return 6
        case .purple:
            return 7
        case .pink:
            return 8
        case .gray:
            return 9
        case .black:
            return 10
        }
    }
    
    var colorData: Color {
        switch self {
        case .red:
            return Color.red
        case .orange:
            return Color.orange
        case .yellow:
            return Color.yellow
        case .green:
            return Color.green
        case .tealBlue:
            return Color.teal
        case .blue:
            return Color.blue
        case .purple:
            return Color.purple
        case .pink:
            return Color.pink
        case .gray:
            return Color.gray
        case .black:
            return Color.black
        }
    }
}

//extension CategoryColor {
//    func toCategoruColor(color: Color) {
//        switch self {
//        case color.red:
//            return 1
//        }
//    }
//}
