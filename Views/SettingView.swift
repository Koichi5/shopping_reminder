//
//  SettingView.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/05.
//

import SwiftUI

struct SettingView: View {
    @State private var showingMenu = false
    @State private var isCategorySettingOn = false
    @State private var categoryList: [Category] = []
    @State private var selectedCategory: Category = Category(name: "その他", color: CategoryColor.gray)
    @ObservedObject var vibrationHepler = VibrationHelper()
    @ObservedObject var darkModeHelper = DarkModeHelper()
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.edgesIgnoringSafeArea(.all)
                List {
                    Section("カテゴリ") {
                        sectionHeader(title: "カテゴリ", isExpanded: $isCategorySettingOn)
                        isCategorySettingOn
                        ? ForEach(self.categoryList.indices, id: \.self) { index in
                            CategoryFieldRow.init(category: self.$categoryList[index])
                        }
                        : nil
                    }.listStyle(.automatic)
                    Section("システム") {
                        Toggle("バイブレーション", isOn: $vibrationHepler.isAllowedVibration)
//                            .environmentObject(VibrationHelper())
                        Toggle("ダークモード", isOn: $darkModeHelper.isDarkMode)
//                            .environmentObject(DarkModeHelper())
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
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    BackButtonView()
                }
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .offset(x: showingMenu ? 200.0 : 0.0, y: 0)
        .animation(.easeOut)
        .task {
            do {
                categoryList = try await CategoryRepository().fetchCategories()
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
            }
        }
    }
}

struct BackButtonView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Button(action: {
            dismiss()
        }, label: {
            Image(systemName: "chevron.backward")
        })
    }
}

//struct SettingView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingView()
//    }
//}
