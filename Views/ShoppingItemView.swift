//
//  ShoppingItemView.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/06.
//

import SwiftUI

struct ShoppingItemView: View {
    @ObservedObject private var shoppingItemRepository = ShoppingItemRepository()
//    @ObservedObject private var categoryRepository = CategoryRepository()
    //    @State private var shoppingItemList = ShoppingItemRepository().shoppingItemList
    @State private var categories: [String] = []
    //    @State private var searchText: String = ""
    
    var body: some View {
        ScrollView (showsIndicators: false){
            if (
                shoppingItemRepository.shoppingItemCategoryList.isEmpty
//                categoryRepository.categoryList.isEmpty
            ) {
                VStack(alignment: .center) {
                    Spacer()
                    Text("アイテムを追加しよう")
                    LottieView(fileName: "shopping_item_view_lottie.json")
                        .frame(width: 250, height: 250)
                    Spacer()
                }
                .frame(
                    maxHeight: .infinity,
                    alignment: .center
                )
            } else {
                ForEach (
                    shoppingItemRepository.shoppingItemCategoryList
//                    categoryRepository.categoryNameList
                    , id: \.hashValue) { categoryName in
                    ZStack {
                        Color.white
                            .cornerRadius(10)
                            .shadow(color: .gray.opacity(0.7), radius: 2, x: 5, y: 5)
                        VStack {
                            Text(categoryName)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                            ForEach (shoppingItemRepository.shoppingItemList) { shoppingItem in
                                shoppingItem.category.name == categoryName
                                ? ShoppingItemComponent(shoppingItem: shoppingItem).padding(.horizontal)
                                : nil
                            }.padding(.bottom)
                        }
                    }
                }.padding(.trailing, 5)
            }
        }
//        .refreshable {
//            Task {
//                try await shoppingItemRepository.addUserSnapshotListener()
////                try await categoryRepository.addCategoryListener()
////                try await shoppingItemRepository.fetchShoppingItemList()
//            }
//        }
        //        .searchable(text: $searchText)
        .task {
            do {
                try await shoppingItemRepository.addUserSnapshotListener()
//                try await categoryRepository.addCategoryListener()
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
    
    //    private var shoppingItemListFiltered: [ShoppingItem] {
    //        let searchResult = shoppingItemRepository.shoppingItemList.filter { $0.name.contains(searchText)}
    //        return searchText.isEmpty ? shoppingItemRepository.shoppingItemList : searchResult
    //    }
}
