//
//  HomeView.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/04.
//

//line.horizontal.3

import SwiftUI

struct HomeView: View {
    enum Field: Hashable {
        case itemName
    }
    @ObservedObject private var shoppingItemRepository = ShoppingItemRepository()
    @ObservedObject var userDefaultsHelper = UserDefaultsHelper()
    @State private var currentDarkModeOn: Bool = false
    @State private var categories: [String] = []
    @FocusState private var focusedField: Field?
    @State private var itemName = ""
    @State private var showingMenu: Bool = false
    @State private var isShowSheet: Bool = false
    @State private var isShowSetting: Bool = false
    @State private var existCategoryList: [Category] = []
    var body: some View {
        NavigationStack {
                VStack(alignment: .leading) {
                    ItemView()
                        .colorScheme(userDefaultsHelper.isDarkModeOn ? .dark : .light)
                }
                .colorScheme(currentDarkModeOn ? .dark : .light)

//                .padding(.horizontal) .frame(maxWidth: .infinity)
                .navigationBarTitle("Home")
                .toolbarColorScheme(currentDarkModeOn ? .dark : .light, for: .navigationBar)
//        NavigationView {
////            VStack(alignment: .leading) {
//            ScrollView (showsIndicators: false){
//                if (
//                    shoppingItemRepository.shoppingItemCategoryList.isEmpty
//                ) {
//    //                GeometryReader { geometry in
//    //                    let frame = geometry.frame(in: .local)
//                        VStack {
//                            Text("アイテムを追加しよう")
//                            LottieView(fileName: "shopping_item_view_lottie.json")
//                                .frame(width: 250, height: 250)
//                        }
//                        .preferredColorScheme(userDefaultsHelper.isDarkModeOn ? .dark : .light)
//                        .padding(.top, 150)
//    //                }
//                } else {
//                    ForEach (
//                        shoppingItemRepository.shoppingItemCategoryList
//                        , id: \.hashValue) { categoryName in
////                            ZStack {
//                                VStack {
//                                    Text(categoryName)
//                                        .frame(maxWidth: .infinity, alignment: .leading)
//    //                                    .padding()
//                                    VStack (spacing: 0) {
//                                        ForEach (shoppingItemRepository.shoppingItemList) { shoppingItem in
//                                            shoppingItem.category.name == categoryName
//                                            ? ItemComponent(shoppingItem: shoppingItem)
//        //                                            .padding(.horizontal)
//
//                                            : nil
//                                        }.background(Color.green)
//                                    }
//                                    .background(Color.pink)
////                                    .padding(.bottom)
//                                }
//                                .background(Color.red)
//                                .shadow(color: .gray.opacity(0.7), radius: 2, x: 5, y: 5)
//                                .preferredColorScheme(userDefaultsHelper.isDarkModeOn ? .dark : .light)
////                                Color.blue
////                                    .cornerRadius(10)
////                                    .shadow(color: .gray.opacity(0.7), radius: 2, x: 5, y: 5)
////                            }
//                        }
//                        .background(Color.brown)
//                        .preferredColorScheme(userDefaultsHelper.isDarkModeOn ? .dark : .light)
//                        .padding(.trailing, 5)
//                }
//            }
//            .preferredColorScheme(userDefaultsHelper.isDarkModeOn ? .dark : .light)
//            .refreshable {
//                Task {
//                    do {
//                        shoppingItemRepository.removeCurrentSnapshotListener()
//                        try await shoppingItemRepository.addUserSnapshotListener()
//                    } catch {
//                        print(error)
//                    }
//                }
//            }
//            .task {
//                do {
//                    shoppingItemRepository.removeCurrentSnapshotListener()
//                    try await shoppingItemRepository.addUserSnapshotListener()
//                    //                try await categoryRepository.addCategoryListener()
//                    updateCategories()
//                } catch {
//                    print(error)
//                }
//            }
//            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    Button(action: {
                        isShowSetting.toggle()
                    }) {
                        Image(systemName: "gearshape")
                            .foregroundColor(Color.foreground)
                    }
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    Button(action: {
                        isShowSheet.toggle()
                    }) {
                        Image(systemName: "plus").foregroundColor(Color.foreground)
                    }
                }
            }
        }
        .colorScheme(currentDarkModeOn ? .dark : .light)
        .sheet(isPresented: $isShowSheet) {
            AddItemView(isShowSheet: $isShowSheet)
        }
        .fullScreenCover(isPresented: $isShowSetting) {
            SettingView()
        }
        .onAppear {
            currentDarkModeOn = userDefaultsHelper.isDarkModeOn
            print("currentDarkModeOn on home page: \(currentDarkModeOn)")
            print("userDefaultsHelper.isDarkModeOn on home page: \(userDefaultsHelper.isDarkModeOn)")
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
//                    ToolbarItem(placement: .destructiveAction) {
//                        Button(action: {
//                            isShowSetting.toggle()
//                        }) {
//                            Image(systemName: "gearshape")
//                                .foregroundColor(Color.foreground)
//                        }
//                    }
//                    ToolbarItemGroup(placement: .bottomBar) {
//                        Spacer()
//                        Button(action: {
//                            isShowSheet.toggle()
//                        }) {
//                            Image(systemName: "plus").foregroundColor(Color.foreground)
//                        }
//                    }
//                }
//                .preferredColorScheme(userDefaultsHelper.isDarkModeOn ? .dark : .light)
//                .padding(.horizontal)
//                .frame(maxWidth: .infinity)
//                .sheet(isPresented: $isShowSheet) {
//                    AddItemView(isShowSheet: $isShowSheet)
//                }
//                .fullScreenCover(isPresented: $isShowSetting) {
//                    SettingView()
//                }
//                .ignoresSafeArea(.keyboard, edges: .bottom)
////                    .preferredColorScheme(userDefaultsHelper.isDarkModeOn ? .dark : .light)
////            }
//        }
//    }
//    private func updateCategories() {
//        var categories = Set<String>()
//        for item in shoppingItemRepository.shoppingItemList {
//            categories.insert(item.category.name)
//        }
//        self.categories = Array(categories)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
