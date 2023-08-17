//
//  ShoppingItem.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/04.
//

import Foundation
import FirebaseFirestoreSwift

struct ShoppingItem: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var category: Category
    var addedAt: Date
    var addedAtString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月d日 H時m分"
        return formatter.string(from: addedAt)
    }
    var isUrlSettingOn: Bool
    var customURL: String?
    var isAlermSettingOn: Bool
    var isDetailSettingOn: Bool
    var isAlermRepeatOn: Bool?
    var alermCycleSeconds: Int?
    var alermCycleString: String?
    var memo: String?
    var latitude: Double?
    var longitude: Double?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case category
        case memo
        case latitude
        case longitude
        case addedAt = "added_at"
        case isUrlSettingOn = "is_url_setting_on"
        case isDetailSettingOn = "is_detail_setting_on"
        case customURL = "custom_url"
        case isAlermSettingOn = "is_alerm_setting_on"
        case isAlermRepeatOn = "is_alerm_repeat_on"
        case alermCycleSeconds = "alerm_cycle_seconds"
        case alermCycleString = "alerm_cycle_string"
    }
    
    init(name: String,
         category: Category,
         addedAt: Date,
         isUrlSettingOn: Bool,
         customURL: String?,
         isAlermSettingOn: Bool,
         isAlermRepeatOn: Bool?,
         isDetailSettingOn: Bool,
         alermCycleSeconds: Int?,
         alermCycleString: String?,
         memo: String?,
         latitude: Double?,
         longitude: Double?
    ) {
        self.name = name
        self.category = category
        self.addedAt = addedAt
        self.isUrlSettingOn = isUrlSettingOn
        self.isAlermSettingOn = isAlermSettingOn
        self.alermCycleSeconds = alermCycleSeconds
        self.alermCycleString = alermCycleString
        self.isAlermRepeatOn = isAlermRepeatOn
        self.isDetailSettingOn = isDetailSettingOn
        self.customURL = customURL
        self.memo = memo
        self.latitude = latitude
        self.longitude = longitude
    }
}
