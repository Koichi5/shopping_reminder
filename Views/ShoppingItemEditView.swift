//
//  ShoppingItemEditView.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/08.
//

import SwiftUI

struct ShoppingItemEditView: View {
    let shoppingItem: ShoppingItem
    var body: some View {
        NavigationStack {
            VStack {
                Text("Hello, World!")
                Text(shoppingItem.name)
            }
            .navigationTitle("Edit")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
//                        Task {
//                            do {
//                                try await ShoppingItemRepository().deleteShoppingItem(shoppingItem: shoppingItem)
//                            } catch {
//                                print(error)
//                            }
//                        }
                    }) {
                        Image(systemName: "trash").foregroundColor(.foreground)
                    }
                }
            }
        }
    }
}

struct ShoppingItemEditView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingItemEditView(shoppingItem: ShoppingItem(name: "name", category: Category(name: "category", color: CategoryColor.blue), addedAt: Date(), expirationDate: Date()))
    }
}
