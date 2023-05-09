//
//  ShoppingItemComponent.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/07.
//

import SwiftUI

struct ShoppingItemComponent: View {
    let shoppingItem: ShoppingItem
    @State private var isDeleted = false
    @State var isPresented = false
    var body: some View {
        NavigationStack {
            VStack (alignment: .leading) {
                Text(shoppingItem.name).strikethrough(isDeleted)
                Text(shoppingItem.category.name)
                Text("color: \(shoppingItem.category.color.colorName)")
                Text(shoppingItem.expirationDate?.ISO8601Format() ?? "There is no epirationDate")
                Text(shoppingItem.addedAt.ISO8601Format())
            }
            .background(shoppingItem.category.color.colorData)
            .cornerRadius(10)
            .navigationDestination(isPresented: $isPresented) {
                ShoppingItemEditView(shoppingItem: shoppingItem)
            }
            .onTapGesture {
                isPresented.toggle()
            }
        }
    }
}

struct ShoppingItemComponent_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingItemComponent(shoppingItem: ShoppingItem(name: "name", category: Category(name: "category", color: CategoryColor.blue), addedAt: Date(), expirationDate: Date(), customURL: "", id: UUID()))
    }
}
