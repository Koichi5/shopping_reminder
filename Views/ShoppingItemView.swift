//
//  ShoppingItemView.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/06.
//

import SwiftUI

struct ShoppingItemView: View {
    @ObservedObject private var shoppingItemRepository = ShoppingItemRepository()
    @State private var shoppingItemList = ShoppingItemRepository().shoppingItemList
    @State private var categories: [String] = []
    
    var body: some View {
        ScrollView (showsIndicators: false){
            ZStack {
                shoppingItemRepository.shoppingItemList.isEmpty ? nil :
                VStack {
                    ForEach (shoppingItemRepository.shoppingItemCategoryList, id: \.hashValue) { shoppingItemCategory in
                        ZStack {
                            Color.white
                                .cornerRadius(10)
                                .shadow(color: .gray.opacity(0.7), radius: 2, x: 5, y: 5)
                            VStack {
                                Text(shoppingItemCategory)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                                ForEach (shoppingItemRepository.shoppingItemList) { shoppingItem in
                                    shoppingItem.category.name == shoppingItemCategory
                                    ? ShoppingItemComponent(shoppingItem: shoppingItem).padding(.horizontal)
                                    : nil
                                }.padding(.vertical)
                            }
                        }
                    }
                }
            }.padding(.trailing, 5)
                .task {
                    do {
                        try await shoppingItemRepository.addUserSnapshotListener()
                        let shoppingItemDict = Dictionary(grouping: shoppingItemList.filter({ $0.category.name != nil })) { $0.category.name }
                        print("shoppingItemDict in shopping item view: \(shoppingItemDict)")
                        updateCategories()
                    } catch {
                        print(error)
                    }
                }
        }
    }
    private func updateCategories() {
        var categories = Set<String>()
        for item in shoppingItemRepository.shoppingItemList {
            categories.insert(item.category.name)
        }
        self.categories = Array(categories)
    }
}

struct ShoppingItemView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingItemView()
    }
}
