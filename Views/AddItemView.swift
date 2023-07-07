//
//  AddItemView.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/05.
//

import SwiftUI

struct AddItemView: View {
    enum Field: Hashable {
        case itemName
    }
    @FocusState private var focusedField: Field?
    @ObservedObject var userDefaultsHelper = UserDefaultsHelper()
    @Binding var isShowSheet: Bool
    @State private var itemName = ""
    @State private var itemUrl = ""
    @State private var itemMemo = ""
    @State private var categoryList: [Category] = []
    @State private var categoryItemList: [CategoryItem] = []
    @State private var selectedCategory: Category? = nil
    @State private var selectedDigitsValue = "1"
    @State private var selectedUnitsValue = "時間ごと"
    @State private var timeIntervalSinceNow = 0
    @State private var isAlermSettingOn = false
    @State private var isUrlSettingOn = false
    @State private var isDetailSettingOn = false
    @State private var isAlermRepeatOn = false
    @State private var shoppingItemDocId = ""
    @State var screen: CGSize!
    @State private var isSidebarOpen = false
    @State private var isNameNilAlertPresented = false
    @State private var isCategoryNilAlertPresented = false
    
    var body: some View {
        VStack {
            ZStack {
                Text("アイテムの追加")
                    .font(.roundedFont())
                HStack {
                    Spacer()
                    Button(action: {
                        isShowSheet = false
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(Color.foreground)
                    }.padding()
                }
            }.padding(.vertical)
            CategoryItemList(
                categoryItemList: $categoryItemList,
                selectedCategory: $selectedCategory
            )
            List {
                Section(header: sectionHeader(title: "メモ", isExpanded: $isDetailSettingOn)) {
                    isDetailSettingOn
                    ?
                    TextField("メモ", text: $itemMemo, axis: .vertical)
                        .listRowBackground(Color.clear)
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    : nil
                }
                Section(header: sectionHeader(title: "アラーム", isExpanded: $isAlermSettingOn)) {
                    isAlermSettingOn
                    ? ItemDigitPicker(
                        selectedDigitsValue: $selectedDigitsValue, selectedUnitsValue: $selectedUnitsValue
                    )
                    .frame(height: 100)
                    .listRowBackground(Color.clear)
                    : nil
                    isAlermSettingOn
                    ? Toggle(isOn: $isAlermRepeatOn) {
                        Text("繰り返し")
                            .font(.roundedFont())
                    }
                        .listRowBackground(Color.clear)
                        .padding(.horizontal)
                    : nil
                }
                Section(header: sectionHeader(title: "URLから買い物", isExpanded: $isUrlSettingOn)) {
                    isUrlSettingOn
                    ?
                    TextField("URL", text: $itemUrl)
                        .listRowBackground(Color.clear)
                        .padding(.horizontal)
                    : nil
                }
            }
            .listStyle(.plain)
            HStack(alignment: .center) {
                TextField("アイテム名", text: $itemName)
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0))
                            .stroke(Color.foreground, lineWidth: 1.0)
                    )
                    .focused($focusedField, equals: .itemName)
                Button(action: {
                    print("-- current selected category: \(selectedCategory)")
                    if (itemName != "") {
                        if (selectedCategory != nil) {
                            VibrationHelper().feedbackVibration()
                            let intSelectedDigitsValue = Int(selectedDigitsValue)
                            timeIntervalSinceNow = TimeHelper().calcSecondsFromString(selectedUnitsValue: selectedUnitsValue, intSelectedDigitsValue: intSelectedDigitsValue ?? 0)
                            Task {
                                do {
                                    shoppingItemDocId =
                                    try await ShoppingItemRepository().addShoppingItemWithDocumentId(shoppingItem: ShoppingItem(
                                        name: itemName,
                                        category: selectedCategory!,
                                        addedAt: Date(),
                                        isUrlSettingOn: isUrlSettingOn,
                                        customURL: itemUrl,
                                        isAlermSettingOn: isAlermSettingOn,
                                        isAlermRepeatOn: isAlermRepeatOn,
                                        isDetailSettingOn: isDetailSettingOn,
                                        alermCycleSeconds: isAlermSettingOn ? timeIntervalSinceNow : nil,
                                        alermCycleString: isAlermSettingOn ?  "\(selectedDigitsValue) \(selectedUnitsValue)" : nil,
                                        memo: itemMemo
                                    )
                                    )
                                    if (isAlermSettingOn) {
                                        NotificationManager().sendIntervalNotification(
                                            shoppingItem: ShoppingItem(
                                                name: itemName,
                                                category: selectedCategory!,
                                                addedAt: Date(),
                                                isUrlSettingOn: isUrlSettingOn,
                                                customURL: itemUrl,
                                                isAlermSettingOn: isAlermSettingOn,
                                                isAlermRepeatOn: isAlermRepeatOn,
                                                isDetailSettingOn: isDetailSettingOn,
                                                alermCycleSeconds: isAlermSettingOn ? timeIntervalSinceNow : nil,
                                                alermCycleString: isAlermSettingOn ? "\(selectedDigitsValue) \(selectedUnitsValue)" : nil,
                                                memo: itemMemo
                                            ),
                                            shoppingItemDocId: shoppingItemDocId
                                        )
                                    }
                                    NotificationManager().fetchAllRegisteredNotifications()
                                    
                                } catch {
                                    print("error occured while adding shopping item: \(error)")
                                }
                            }
                            isShowSheet = false
                        } else {
                            VibrationHelper().errorVibration()
                            isCategoryNilAlertPresented = true
                        }
                    } else {
                        VibrationHelper().errorVibration()
                        isNameNilAlertPresented = true
                    }
                }) {
                    Text("追加")
                        .font(.roundedFont())
                        .padding(10)
                        .foregroundColor(Color.white)
                        .background(itemName == ""
                                    ? Color.gray.cornerRadius(10)
                                    : Color.blue.cornerRadius(10)
                        )
                }
                .padding(.horizontal, 10)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .onAppear {
            screen = UIScreen.main.bounds.size
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                focusedField = .itemName
            }
            Task {
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
        .alert (isPresented: $isNameNilAlertPresented) {
            Alert(title: Text("アイテムの名前が指定されていません"))
        }
        .alert (isPresented: $isCategoryNilAlertPresented) {
            Alert(title: Text("アイテムのカテゴリが指定されていません"))
        }
    }
}

extension AddItemView {
    private func sectionHeader(title: String, isExpanded: Binding<Bool>) -> some View {
        Button(action: {isExpanded.wrappedValue.toggle()}) {
            VStack {
                HStack {
                    Text(title)
                    Spacer()
                    Image(systemName: isExpanded.wrappedValue ? "chevron.up" : "chevron.down")
                }
                if !isExpanded.wrappedValue {
                    Divider()
                } else {
                    Divider().frame(width: 0, height: 0)
                }
            }
        }
        .foregroundColor(Color.gray)
    }
}



