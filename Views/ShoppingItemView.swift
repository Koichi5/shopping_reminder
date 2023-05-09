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
            Text("Hello, World!")
            ForEach (shoppingItemRepository.shoppingItemList) { shoppingItem in
                if categories.contains(shoppingItem.category.name) {
//                    CategoryView(shoppingItem: shoppingItem)
                    Text("")
                } else {
                    ShoppingItemComponent(shoppingItem: shoppingItem)
                }
            }
//            ForEach (shoppingItemRepository.shoppingItemList) { shoppingItem in
//                ShoppingItemComponent(shoppingItem: shoppingItem)
//            }
            Button(action: {
                print("shoppingItemRepository.shoppingItemList: \(shoppingItemRepository.shoppingItemList)")
            }) {
                Text("print")
            }
        }
        .onAppear {
            Task {
                do {
                    try await shoppingItemRepository.addUserSnapshotListener()
                    updateCategories()
                } catch {}
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

//struct ShoppingItemView: View {
//    @ObservedObject private var shoppingItemRepository = ShoppingItemRepository()
//    @State private var categoryList: [String] = []
//    let columns: [GridItem] = Array(repeating: .init(.flexible()),count: 2)
//
//    var body: some View {
//        ScrollView {
//            Button(action: {
//                print(categoryList)
//                print(shoppingItemRepository.shoppingItemList)
//            }){
//                Text("button")
//            }
//            LazyVGrid(columns: columns) {
//                ForEach (categoryList, id: \.self) { category in
//                    Section(header: Text(category)) {
//                        ForEach (shoppingItemRepository.shoppingItemList.filter { $0.category.name == category }, id: \.id) { shoppingItem in
//                            Text(shoppingItem.name)
////                            ShoppingItemComponent(shoppingItem: shoppingItem)
//                        }
//                    }
//                }
//            }
//            .padding()
//        }
//        .onAppear {
//            Task {
//                do {
//                    try await shoppingItemRepository.addUserSnapshotListener()
//                    updateCategoryList()
//                } catch {}
//            }
//        }
//    }
//
//    private func updateCategoryList() {
//        var categories = Set<String>()
//        for item in shoppingItemRepository.shoppingItemList {
//            categories.insert(item.category.name)
//        }
//        self.categoryList = Array(categories)
//    }
//}


//struct ShoppingItemView: View {
//    @ObservedObject private var shoppingItemRepository = ShoppingItemRepository()
//    var categoryList: [String] = []
//    @State private var categories: [String] = []
//
//    var body: some View {
//        VStack {
//            Text("Hello, World!")
//            ForEach (shoppingItemRepository.shoppingItemList) { shoppingItem in
//                if categories.contains(shoppingItem.category.name) {
////                    CategoryView(shoppingItem: shoppingItem)
//                    Text("")
//                } else {
//                    ShoppingItemComponent(shoppingItem: shoppingItem)
//                }
//            }
////            ForEach (shoppingItemRepository.shoppingItemList) { shoppingItem in
////                ShoppingItemComponent(shoppingItem: shoppingItem)
////            }
//            Button(action: {
//                print("shoppingItemRepository.shoppingItemList: \(shoppingItemRepository.shoppingItemList)")
//            }) {
//                Text("print")
//            }
//        }
//        .onAppear {
//            Task {
//                do {
//                    try await shoppingItemRepository.addUserSnapshotListener()
//                    updateCategories()
//                } catch {}
//            }
//        }
//    }
//    private func updateCategories() {
//        var categories = Set<String>()
//        for item in shoppingItemRepository.shoppingItemList {
//            categories.insert(item.category.name)
//        }
//        self.categories = Array(categories)
//    }
//}

struct ShoppingItemView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingItemView()
    }
}
