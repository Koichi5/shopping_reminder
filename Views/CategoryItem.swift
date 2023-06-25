//
//  CategoryItem.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/05.
//

import SwiftUI

struct CategoryItem: View, Identifiable {
    @ObservedObject var userDefaultsHelper = UserDefaultsHelper()
    let id = UUID()
    var isSelected = false
    let category: Category
    var body: some View {
        Text(category.name)
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .foregroundColor(isSelected ? .white : category.color.colorData)
            .background(isSelected ? category.color.colorData : Color.background)
            .cornerRadius(40)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(category.color.colorData, lineWidth: 1.5)
            )
            .onTapGesture {}
            .preferredColorScheme(userDefaultsHelper.isDarkModeOn ? .dark : .light)
    }
}

//struct CategoryItem_Previews: PreviewProvider {
//    static var previews: some View {
//        CategoryItem(category: Category(name: "Clothes", color: CategoryColor.red))
//    }
//}
