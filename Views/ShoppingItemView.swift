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
    //    let shoppingItemDict = Dictionary(grouping: shoppingItemList.filter({ $0.category.name != nil })) { $0.category.name }
    //    var shoppingItemDict = [String: [ShoppingItem]]()
    //    for shoppingItem in shoppingItemList {
    //        if let categoryName = shoppingItem.category?.name {
    //            if shoppingItemDict[categoryName] == nil {
    //                shoppingItemDict[categoryName] = [shoppingItem]
    //            } else {
    //                shoppingItemDict[categoryName]?.append(shoppingItem)
    //            }
    //        }
    //    }
    //    @State private var categories: [String] = []
    
    var body: some View {
        VStack {
            ForEach (shoppingItemRepository.shoppingItemList) { shoppingItem in
                ShoppingItemComponent(shoppingItem: shoppingItem)
            }
            ForEach (shoppingItemRepository.shoppingItemCategoryList, id: \.hashValue) { shoppingItemCategory in
                Text(shoppingItemCategory)
                ForEach (shoppingItemRepository.shoppingItemList) { shoppingItem in
                    shoppingItem.category.name == shoppingItemCategory
                    ? Text(shoppingItem.name)
                    : nil
                }
            }
        }
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
