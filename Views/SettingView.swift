//
//  SettingView.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/05.
//

import SwiftUI

struct SettingView: View {
    @State private var showingMenu = false
    @State private var isCategorySettringOn = false
    @State private var categoryList: [Category] = []
    @State private var categoryItemList: [CategoryItem] = []
    @State private var selectedCategory: Category = Category(name: "その他", color: CategoryColor.gray)
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.edgesIgnoringSafeArea(.all)
                List {
                    Section("カテゴリ") {
                        sectionHeader(title: "カテゴリ", isExpanded: $isCategorySettringOn)
                        isCategorySettringOn
                        ? VStack {
                            ForEach(categoryItemList) { categoryItem in
                                Text(categoryItem.category.name)
//                                TextField("\(categoryItem.category.name)", text: T##Binding<String>)
                            }
                        }
                        : nil
                    }.listStyle(.automatic)
                    Section("システム") {
                        Text("バイブレーション")
                        Text("ダークモード")
                    }
                    HStack {
                        DialogHelper(
                            systemName: nil,
                            buttonText: "ログアウト",
                            titleText: "ログアウトしますか？",
                            messageText: "",
                            primaryButtonText: "いいえ",
                            secondaryButtonText: "ログアウト",
                            primaryButtonAction: nil,
                            secondaryButtonAction: {
                                AuthViewModel().signOut()
                            }
                        )
                        Spacer()
                    }
                    .contentShape(Rectangle())
                }
            }
            .navigationBarTitle("Settings")
            .navigationBarTitleDisplayMode(showingMenu ? .inline : .automatic)
            .toolbar {
                ToolbarItem (placement: .cancellationAction) {
                    Button (action: {self.showingMenu.toggle()}) {
                        Image(systemName: showingMenu ? "xmark" : "line.horizontal.3")
                            .foregroundColor(Color.foreground)
                    }
                }
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .offset(x: showingMenu ? 200.0 : 0.0, y: 0)
        .animation(.easeOut)
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

extension SettingView {
    private func sectionHeader(title: String, isExpanded: Binding<Bool>) -> some View {
        Button(action: {isExpanded.wrappedValue.toggle()}) {
            VStack {
                HStack {
                    Text(title)
                        .foregroundColor(Color.foreground)
                    Spacer()
                    Image(systemName: isExpanded.wrappedValue ? "chevron.up" : "chevron.down")
                        .foregroundColor(Color.gray)
                }
//                if !isExpanded.wrappedValue {
//                    Divider()
//                } else {
//                    Divider()
//                        .frame(width: 0, height: 0)
//                }
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
