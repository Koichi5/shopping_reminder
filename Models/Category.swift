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
    var style: CategoryStyle?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case color
        case items
        case style
    }
    
    init(
        name: String, color: CategoryColor,
        items: [ShoppingItem] = [], style: CategoryStyle) {
            self.name = name
            self.color = color
            self.items = items
            self.style = style
        }
}

enum CategoryColor: Int, Codable, CaseIterable {
    case red
    case orange
    case yellow
    case green
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
    
    var colorNum: Int{
        switch self {
        case .red:
            return 1
        case .orange:
            return 2
        case .yellow:
            return 3
        case .green:
            return 4
        case .blue:
            return 5
        case .purple:
            return 6
        case .pink:
            return 7
        case .gray:
            return 8
        case .black:
            return 9
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

