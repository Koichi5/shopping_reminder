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
    @State var isEditPresented = false
    @State var isUrlLinkPresented = false
    var body: some View {
        NavigationStack {
            HStack {
                Text("\(shoppingItem.name)")
                Spacer()
                shoppingItem.customURL == "" ? nil :
                Menu {
                    Button(action: {
                            print("is url link presented")
                            if let url = URL(string: shoppingItem.customURL ?? "") {
                                if(shoppingItem.customURL == "") {
                                    print("custom url is nil")
                                }
                                UIApplication.shared.open(url, options: [.universalLinksOnly: false], completionHandler: { completed in
                                    print(completed)
                                })
                            }
                    }) {
                        Text("URLを開く")
                    }
                } label: {
                    Image(systemName: "link")
                        .foregroundColor(Color.foreground)
                }
                Button(action: {
                    isEditPresented.toggle()
                }) {
                    Image(systemName: "pencil")
                        .foregroundColor(Color.foreground)
                }
            }
            .background(shoppingItem.category.color.colorData)
            .cornerRadius(10)
            .navigationDestination(isPresented: $isEditPresented) {
                ShoppingItemEditView(shoppingItem: shoppingItem)
            }
//            .onTapGesture {
//                isEditPresented.toggle()
//                print("shoppingItem id on component: \(shoppingItem.id)")
//            }
//            .onLongPressGesture (
//                minimumDuration: 0.5, maximumDistance: 10
//            ) {
//                print("long press")
//                isEditPresented.toggle()
//            }
        }
    }
}

struct ShoppingItemComponent_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingItemComponent(shoppingItem: ShoppingItem(
            name: "name",
            category: Category(name: "category", color: CategoryColor.blue),
            addedAt: Date(),
            isAlermRepeatOn: false,
//            expirationDate: Date(),
            alermCycleSeconds: 100,
            alermCycleString: "",
            customURL: ""
//            id: nil
        ))
    }
}
