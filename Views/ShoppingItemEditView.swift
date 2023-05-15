//
//  ShoppingItemEditView.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/13.
//

import SwiftUI

struct ShoppingItemEditView: View {
    @State private var isShowSheet: Bool = false
    let shoppingItem: ShoppingItem
    var body: some View {
        NavigationStack {
            VStack {
                Text(shoppingItem.name)
                shoppingItem.customURL != ""
                ? UrlButton(
                    buttonText: "URL",
                    sourceUrl: shoppingItem.customURL!
                )
                : nil
                shoppingItem.alermCycleString != ""
                ? Text(shoppingItem.alermCycleString!)
                : nil
            }
            .navigationTitle("\(shoppingItem.name)")
            .toolbar {
                ToolbarItemGroup (placement: .bottomBar) {
                        DialogHelper(
                            systemName: "trash",
                            titleText: "このアイテムを削除しますか？",
                            messageText: nil,
                            primaryButtonText: "キャンセル",
                            secondaryButtonText: "削除",
                            primaryButtonAction: nil,
                            secondaryButtonAction: {
                                print("secondary button action fired")
                                NotificationManager().deleteNotification(shoppingItemIndentifier: [shoppingItem.id ?? ""])
                            Task {
                                do {
                                    try await ShoppingItemRepository().deleteShoppingItem(shoppingItem: shoppingItem)
                                } catch {
                                    print(error)
                                }
                            }
                                NotificationManager().fetchAllRegisteredNotifications()
                        }
                        )
                    Button(action: {
                        isShowSheet = true
                    }) {
                        Image(systemName: "pencil").foregroundColor(Color.foreground)
                    }
                }
            }
        }.sheet(isPresented: $isShowSheet) {
            ShoppingItemEditModal(isShowSheet: $isShowSheet, shoppingItem: shoppingItem)
        }
    }
}

struct ShoppingItemEditView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingItemEditView(
            shoppingItem: ShoppingItem(
                name: "キッチンペーパー",
                category: Category(
                    name: "clothes",
                    color: CategoryColor.red),
                addedAt: Date(),
                isAlermRepeatOn: false,
                alermCycleSeconds: 100,
                alermCycleString: "10日",
                customURL: "https://swappli.com/switcheditmode/"
            ))
    }
}
