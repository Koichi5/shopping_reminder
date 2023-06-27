//
//  SettingView.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/05.
//

import SwiftUI

struct SettingView: View {
    @State private var isCategorySettingOn = false
    @State private var categoryList: [Category] = []
    @State private var selectedCategory: Category = Category(
        name: "その他",
        color: CategoryColor.gray,
        style: CategoryStyle(color: CategoryColor.gray)
    )
    let notificaitonManager = NotificationManager()
    let shareHelper = ShareHelper()
//    @AppStorage("isDarkMode") private var isDarkMode = false
//    @AppStorage("isVibrationOn") private var isVibrationOn = true
    //    @ObservedObject var vibrationHepler = VibrationHelper()
    //    @ObservedObject var darkModeHelper = DarkModeHelper()
    @ObservedObject var userDefaultsHelper = UserDefaultsHelper()
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.edgesIgnoringSafeArea(.all)
                List {
                    Section("カテゴリ") {
                        sectionHeader(title: "カテゴリ", isExpanded: $isCategorySettingOn)
                        isCategorySettingOn
                        ?
                        ForEach(self.categoryList.indices, id: \.self) { index in
                            CategoryFieldRow.init(
                                category: self.$categoryList[index]
                            )
                        }
                        : nil
                    }.listStyle(.automatic)
                    Section("システム") {
                        Toggle(isOn: $userDefaultsHelper.isVibrationAllowed) {
                            Text("バイブレーション")
                                .font(.roundedFont())
                                .foregroundColor(Color.foreground)
                        }
//                        Toggle("ダークモード", isOn: $userDefaultsHelper.isDarkModeOn)
                        Text("通知設定")
                            .font(.roundedFont())
                            .foregroundColor(Color.foreground)
                            .onTapGesture {
                                UIApplication.shared.open(
                                    URL(string: UIApplication.openSettingsURLString)!
                                )
                            }
                        //                        HStack (alignment: .center) {
                        DialogHelper(
                            systemName: nil,
                            buttonText: "全アラーム削除",
                            titleText: "すべてのアラームを削除しますか？",
                            messageText: "この処理は取り消すことができません。",
                            primaryButtonText: "いいえ",
                            secondaryButtonText: "削除",
                            primaryButtonAction: nil,
                            secondaryButtonAction: {
                                notificaitonManager.deleteAllNotifications()
                            }
                        )
                        .padding(.bottom, 7)
                        .contentShape(Rectangle())
                    }
                    Section("その他") {
                        ShareLink(
                            item: URL(string: "https://developer.apple.com/documentation/SwiftUI/ShareLink")!,
                            message: Text("Shopping Reminder を使ってみよう！")
                        ) {
                            Text("アプリを共有する")
                                .font(.roundedFont())
                                .foregroundColor(Color.foreground)
                        }
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
                        .padding(.bottom, 7)
                        .contentShape(Rectangle())
                    }
                }
            }
            .navigationBarTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    BackButtonView()
                }
            }
        }
        .task {
            do {
                categoryList = try await CategoryRepository().fetchCategories()
            } catch {
                print(error)
            }
        }
//        .preferredColorScheme(userDefaultsHelper.isDarkModeOn ? .dark : .light)
    }
}

extension SettingView {
    private func sectionHeader(title: String, isExpanded: Binding<Bool>) -> some View {
        Button(action: {isExpanded.wrappedValue.toggle()}) {
            VStack {
                HStack {
                    Text(title)
                        .font(.roundedFont())
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

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
