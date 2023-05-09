//
//  ShoppingItem.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/04.
//

import Foundation

struct ShoppingItem: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: Category
    var addedAt: Date
    var addedAtString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月d日 H時m分"
        return formatter.string(from: addedAt)
    }
    var customURL: String?
    var expirationDate: Date?
    var expirationDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月d日 H時m分"
        return formatter.string(from: expirationDate ?? Date()
        )
    }
    
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
//        case categoryName = "category_name"
        case category
        case addedAt = "added_at"
        case customURL = "custom_url"
        case expirationDate = "expiration_date"
    }
    
    init(name: String,
//         category: String,
         category: Category,
         addedAt: Date, expirationDate: Date? = nil, customURL: String? = nil, id: UUID = UUID()) {
        self.id = id
        self.name = name
        self.category = category
        self.addedAt = addedAt
        self.expirationDate = expirationDate
        self.customURL = customURL
    }
    
//    func moveItem(_ item: ShoppingItem, fromCategory sourceCategory: Category, toCategory destinationCategory: Category) {
//        // 1. 移動元のカテゴリーからアイテムを削除する。
//        sourceCategory.items.removeAll(where: { $0.id == item.id })
//
//        // 2. 移動先のカテゴリーにアイテムを追加する。
//        destinationCategory.items.append(item)
//
//        // 3. Firebase のデータベース上で、アイテムの `categoryId` を移動先のカテゴリーの ID に更新する。
//        let db = Firestore.firestore()
//        let itemRef = db.collection("shoppingItems").document(item.id.uuidString)
//        itemRef.updateData(["categoryId": destinationCategory.id.uuidString])
//    }
}
