////
////  CategoryGridView.swift
////  shopping_reminder
////
////  Created by Koichi Kishimoto on 2023/05/14.
////
//
//import SwiftUI
//
//struct CategoryGridView: View {
//    let categoryName: String
//    let shoppingItems: [ShoppingItem]
//
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(shoppingItems) { shoppingItem in
//                    NavigationLink(destination: ItemComponent(shoppingItem: shoppingItem)) {
//                        Text(shoppingItem.name)
//                    }
//                }
//            }
//            .navigationTitle(categoryName)
//        }
//    }
//}
//
//struct CategoryGridViews: View {
////    let shoppingItemDict: [String: [ShoppingItem]]
//    @State private var shoppingItemDict: [String: [ShoppingItem]] = ["": []]
//
//    var body: some View {
//        ScrollView {
////            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
////                ForEach(existCategoryList) { category in
////                    NavigationLink (destination: CategoryGridView(categoryName: category, shoppingItems: shoppingItems))
////                }
////            }
////            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
////                ForEach(shoppingItemDict.sorted(by: { $0.key < $1.key }), id: \.key) { category, shoppingItems in
////                    NavigationLink(destination: CategoryGridView(categoryName: category, shoppingItems: shoppingItems)) {
////                        Text(category)
////                            .font(.headline)
////                            .padding()
////                            .foregroundColor(.white)
////                            .background(Color.blue)
////                            .cornerRadius(10)
////                    }
////                }
////            }
////            .padding()
//        }
//        .navigationTitle("Shopping List")
//    }
//}
//
//
////struct CategoryGridView_Previews: PreviewProvider {
////    static var previews: some View {
////        CategoryGridView()
////    }
////}
