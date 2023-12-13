//
//  SettingView.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/05.
//

import SwiftUI

struct SettingView: View {
    //    @FocusState var focusField: UUID?
    @Binding var isShowSetting: Bool
    @State private var isCategorySettingOn = false
    @State private var categoryList: [Category] = []
    @State private var selectedCategory: Category = Category(
        name: "その他",
        color: CategoryColor.gray,
        style: CategoryStyle(color: CategoryColor.gray)
    )
    @ObservedObject var authViewModel: AuthViewModel = AuthViewModel()
    let notificaitonManager = NotificationManager()
    let shareHelper = ShareHelper()
    private func addCategory(category: Category) async throws {
        try await CategoryRepository().addCategory(category: category)
    }
    @ObservedObject var userDefaultsHelper = UserDefaultsHelper()
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                List {
                    Section("カテゴリ") {
                        sectionHeader(title: "カテゴリ", isExpanded: $isCategorySettingOn)
                        if isCategorySettingOn {
                            VStack {
                                ForEach(self.categoryList.indices, id: \.self) { index in
                                    CategoryFieldRow(
                                        category: self.$categoryList[index]
                                    )
                                    .padding(.vertical, 5)
                                }
                                HStack {
                                    NavigationLink("カテゴリ追加") {
                                        AddCategoryView()
                                            .navigationTitle("カテゴリ追加")
                                    }
                                    .padding(.leading)
                                    .padding(.vertical, 5)
                                    Spacer()
                                }
                            }
                        }
                    }
                    .listStyle(.automatic)
                    Section("システム") {
                        Toggle(isOn: $userDefaultsHelper.isVibrationAllowed) {
                            Text("バイブレーション")
                                .font(.roundedFont())
                                .foregroundColor(Color.foreground)
                        }
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
                                authViewModel.signOut()
                            }
                        )
                        .padding(.bottom, 7)
                        .contentShape(Rectangle())
                        DialogHelper(
                            systemName: nil,
                            buttonText: "アカウント削除",
                            titleText: "アカウントを削除しますか？",
                            messageText: "この処理は取り消すことができません",
                            primaryButtonText: "いいえ",
                            secondaryButtonText: "削除",
                            primaryButtonAction: nil,
                            secondaryButtonAction: {
                                authViewModel.deleteUser()
                            }
                        )
                    }
                }
                .navigationBarTitle("設定")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(action: {
                            isShowSetting = false
                        }, label: {
                            Image(systemName: "chevron.backward")
                                .foregroundColor(Color.foreground)
                        })
                    }
                }
                .fullScreenCover(isPresented: $authViewModel.isSignedOut) {
                    EntryAuthView()
                }
            }
            .onAppear {
                Task {
                    do {
                        categoryList = try await CategoryRepository().fetchCategories()
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
}

extension SettingView {
    private func sectionHeader(title: String, isExpanded: Binding<Bool>) -> some View {
        Button(action: {isExpanded.wrappedValue.toggle()}) {
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

struct BackButtonView: View {
    //    @Environment(\.dismiss) var dismiss
    var body: some View {
        Button(action: {
            // TODO: dismissWindow
            //            dismiss()
        }, label: {
            Image(systemName: "chevron.backward")
                .foregroundColor(Color.foreground)
        })
    }
}

//struct SettingView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingView()
//    }
//}
