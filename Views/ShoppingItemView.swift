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
    var categoryList: [String] = []
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
//                    if let categoryName = shoppingItem.category?.name {
//                        if shoppingItemDict[categoryName] == nil {
//                            shoppingItemDict[categoryName] = [shoppingItem]
//                        } else {
//                            shoppingItemDict[categoryName]?.append(shoppingItem)
//                        }
//                    }
                

//                if categories.contains(shoppingItem.category.name) {
//                    //                    CategoryView(shoppingItem: shoppingItem)
//                    Text("リストを正確に取得できませんでした。")
//                } else {
                    ShoppingItemComponent(shoppingItem: shoppingItem)
                }
//            Button(action: {
//                NotificationManager().deleteAllNotifications()
//            }) {
//                Text("Delete all notifications")
//            }
        }
        .task {
            do {
                try await shoppingItemRepository.addUserSnapshotListener()
                let shoppingItemDict = Dictionary(grouping: shoppingItemList.filter({ $0.category.name != nil })) { $0.category.name }
                print("shoppingItemDict in shopping item view: \(shoppingItemDict)")
//              updateCategories()
            } catch {
                print(error)
            }
        }
    }
//        private func updateCategories() {
//            var categories = Set<String>()
//            for item in shoppingItemRepository.shoppingItemList {
//                categories.insert(item.category.name)
//            }
//            self.categories = Array(categories)
//        }
}

struct ShoppingItemView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingItemView()
    }
}
