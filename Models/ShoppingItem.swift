//
//  ShoppingItem.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/04.
//

import Foundation
import FirebaseFirestoreSwift

struct ShoppingItem: Identifiable, Codable {
//    let id: UUID
    @DocumentID var id: String?
    var name: String
    var category: Category
    var addedAt: Date
    var addedAtString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月d日 H時m分"
        return formatter.string(from: addedAt)
    }
//    var priority: Int
    var isUrlSettingOn: Bool
    var customURL: String?
    var isAlermSettingOn: Bool
    var isAlermRepeatOn: Bool?
    var alermCycleSeconds: Int?
    var alermCycleString: String?
//    var expirationDate: Date?
//    var expirationDateString: String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy年M月d日 H時m分"
//        return formatter.string(from: expirationDate ?? Date()
//        )
//    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
//        case categoryName = "category_name"
        case category
//        case priority
        case addedAt = "added_at"
        case isUrlSettingOn = "is_url_setting_on"
        case customURL = "custom_url"
        case isAlermSettingOn = "is_alerm_setting_on"
        case isAlermRepeatOn = "is_alerm_repeat_on"
        case alermCycleSeconds = "alerm_cycle_seconds"
        case alermCycleString = "alerm_cycle_string"
//        case expirationDate = "expiration_date"
    }
    
    init(name: String,
//         category: String,
         category: Category,
//         priority: Int,
         addedAt: Date,
//         expirationDate: Date? = nil,
         isUrlSettingOn: Bool,
         customURL: String?,
         isAlermSettingOn: Bool,
         isAlermRepeatOn: Bool?,
         alermCycleSeconds: Int?,
         alermCycleString: String?
//         customURL: String? = nil,
//         id: UUID = UUID()
//         id: String? = UUID().uuidString
    ) {
//        self.id = id
        self.name = name
        self.category = category
//        self.priority = priority
        self.addedAt = addedAt
//        self.expirationDate = expirationDate
        self.isUrlSettingOn = isUrlSettingOn
        self.isAlermSettingOn = isAlermSettingOn
        self.alermCycleSeconds = alermCycleSeconds
        self.alermCycleString = alermCycleString
        self.isAlermRepeatOn = isAlermRepeatOn
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
