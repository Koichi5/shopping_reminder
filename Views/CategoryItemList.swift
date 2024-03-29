//
//  CategoryItemList.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/17.
//

import SwiftUI

struct CategoryItemList: View {
    @ObservedObject var userDefaultsHelper = UserDefaultsHelper()
    @Binding var categoryItemList: [CategoryItem]
    @Binding var selectedCategory: Category?
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach (categoryItemList) { categoryItem in
                    Text(categoryItem.category.name)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .foregroundColor(categoryItem.isSelected ? .white : categoryItem.category.color.colorData)
                        .background(categoryItem.isSelected ? categoryItem.category.color.colorData : Color.background)
                        .cornerRadius(40)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(categoryItem.category.color.colorData, lineWidth: 1.5)
                        ).onTapGesture {
                            categoryItemList.indices.forEach { index in
                                categoryItemList[index].isSelected = categoryItemList[index].id == categoryItem.id
                                if (categoryItemList[index].isSelected) {
                                    selectedCategory = categoryItem.category
//                                    isSomeCategorySelected = true
                                }
                            }
                            VibrationHelper().feedbackVibration()
                        }
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal)
        }
    }
}
