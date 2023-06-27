//
//  ItemView.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/06.
//

import SwiftUI

struct ItemView: View {
    @ObservedObject private var shoppingItemRepository = ShoppingItemRepository()
    @ObservedObject var userDefaultsHelper = UserDefaultsHelper()
    @State private var categories: [String] = []

    var body: some View {
        NavigationView {
            ScrollView (showsIndicators: false){
                if (
                    shoppingItemRepository.shoppingItemCategoryList.isEmpty
                ) {
    //                GeometryReader { geometry in
    //                    let frame = geometry.frame(in: .local)
                        VStack {
                            Text("アイテムを追加しよう")
                                .font(.roundedBoldFont())
                                .foregroundColor(Color.foreground)
                            LottieView(fileName: "shopping_item_view_lottie.json")
                                .frame(width: 250, height: 250)
                        }
                        .padding(.top, 150)
    //                }
                } else {
                    ForEach (
                        shoppingItemRepository.shoppingItemCategoryList
                        , id: \.hashValue) { categoryName in
                            ZStack {
                                Color.itemCard
                                    .cornerRadius(10)
                                    .shadow(color: .gray.opacity(0.7), radius: 2, x: 5, y: 5)
                                VStack {
                                    Text(categoryName)
                                        .font(.roundedBoldFont())
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding()
                                    ForEach (shoppingItemRepository.shoppingItemList) { shoppingItem in
                                        shoppingItem.category.name == categoryName
                                        ? ItemComponent(shoppingItem: shoppingItem).padding(.horizontal)
                                        : nil
                                    }.padding(.bottom)
                                }
                            }
                        }
                        .padding(.trailing, 5)
                        .background(Color.background)
                }
            }
            .refreshable {
                Task {
                    do {
                        shoppingItemRepository.removeCurrentSnapshotListener()
                        try await shoppingItemRepository.addUserSnapshotListener()
                    } catch {
                        print(error)
                    }
                }
            }
            .task {
                do {
                    shoppingItemRepository.removeCurrentSnapshotListener()
                    try await shoppingItemRepository.addUserSnapshotListener()
                    //                try await categoryRepository.addCategoryListener()
                    updateCategories()
                } catch {
                    print(error)
                }
            }
        }
//        .background(Color.background)
//        .colorScheme(userDefaultsHelper.isDarkModeOn ? .dark : .light)
//        .preferredColorScheme(userDefaultsHelper.isDarkModeOn ? .dark : .light)
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

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView()
    }
}
