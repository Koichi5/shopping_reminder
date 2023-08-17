//
//  FirestoreUser.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/04.
//

import Foundation
import FirebaseFirestoreSwift

class FirebaseUser: Identifiable, Codable {
    @DocumentID var id: String?
    let email: String
    var items: [ShoppingItem]
    var categories: [Category]
    
    private enum CodingKeys: String, CodingKey {
        case email
        case items
        case categories
    }

    init(id: String, email: String, items: [ShoppingItem] = [], categories: [Category] = []) {
        self.id = id
        self.email = email
        self.items = items
        self.categories = categories
    }
}
