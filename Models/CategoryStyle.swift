//
//  CategoryStyle.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/06/20.
//

import Foundation
import FirebaseFirestoreSwift

struct CategoryStyle: Identifiable, Codable {
    @DocumentID var id: String?
    var color: CategoryColor
    
    private enum CodingKeys: String, CodingKey {
        case id
        case color
    }
    
    init(color: CategoryColor) {
        self.color = color
    }
}
