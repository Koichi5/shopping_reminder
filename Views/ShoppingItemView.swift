//
//  ShoppingItemView.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/06.
//

import SwiftUI

struct ShoppingItemView: View {
    @ObservedObject private var shoppingItemRepository = ShoppingItemRepository()
    var categoryList: [String] = []
    @State private var categories: [String] = []
    
    var body: some View {
        VStack {
            ForEach (shoppingItemRepository.shoppingItemList) { shoppingItem in
//                if categories.contains(shoppingItem.category.name) {
//                    //                    CategoryView(shoppingItem: shoppingItem)
//                    Text("リストを正確に取得できませんでした。")
//                } else {
                    ShoppingItemComponent(shoppingItem: shoppingItem)
                }
//            }
            //            ForEach (shoppingItemRepository.shoppingItemList) { shoppingItem in
            //                ShoppingItemComponent(shoppingItem: shoppingItem)
            //            }
            Button(action: {
                NotificationManager().deleteAllNotifications()
            }) {
                Text("Delete all notifications")
            }
        }
        .task {
            do {
                try await shoppingItemRepository.addUserSnapshotListener()
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
