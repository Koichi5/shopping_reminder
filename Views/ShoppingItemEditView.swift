//
//  ShoppingItemEditView.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/13.
//

import SwiftUI

struct ShoppingItemEditView: View {
    @State private var isShowSheet: Bool = false
    @State private var defaultShoppingItemName = ""
    @State private var categoryList: [Category] = []
    @State private var categoryItemList: [CategoryItem] = []
    @State private var selectedCategory: Category = Category(name: "その他", color: CategoryColor.gray)
    let shoppingItem: ShoppingItem
    var body: some View {
        NavigationStack {
            VStack {
                TextField("", text: $defaultShoppingItemName)
                    .onAppear {
                        defaultShoppingItemName = shoppingItem.name
                    }
                    .font(.largeTitle.bold())
                    .padding(.horizontal)
                Spacer()
                CategoryItemList(categoryItemList: $categoryItemList, selectedCategory: $selectedCategory)
                shoppingItem.customURL != ""
                ?
                HStack {
                    UrlButton(
                        systemName: "cart",
                        buttonText: "\(shoppingItem.customURL ?? "URL")",
                    sourceUrl: shoppingItem.customURL!
                )}
                : nil
                shoppingItem.alermCycleString != ""
                ? Text(shoppingItem.alermCycleString ?? "")
                : nil
                Spacer()
            }
//            .navigationTitle("\(shoppingItem.name)")
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
        .task {
            do {
                categoryList = try await CategoryRepository().fetchCategories()
                for category in categoryList {
                    categoryItemList.append(CategoryItem(category: category))
                }
            } catch {
                print(error)
            }
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
