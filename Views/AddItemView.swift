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
    @Binding var isShowSheet: Bool
    //    @Binding var existCategoryList: [Category]
    //    @Binding var shoppingItemDict: [String: [ShoppingItem]]
    @State private var itemName = ""
    @State private var itemUrl = ""
    @State private var categoryList: [Category] = []
    @State private var categoryItemList: [CategoryItem] = []
    @State private var selectedCategory: Category = Category(name: "その他", color: CategoryColor.gray)
    @State private var selectedDigitsValue = "1"
    @State private var selectedUnitsValue = "時間ごと"
    @State private var timeIntervalSinceNow = 0
    @State private var isAlermSettingOn = false
    @State private var isUrlSettingOn = false
    @State private var isAlermRepeatOn = false
    @State private var shoppingItemDocId = ""
    @State var screen: CGSize!
    @State private var isSidebarOpen = false
    //    @ObservedObject var keyboardHelper = KeyboardHelper()
    
    var body: some View {
        VStack {
            ZStack {
                Text("アイテムの追加")
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
            CategoryItemList(categoryItemList: $categoryItemList, selectedCategory: $selectedCategory
//                             initialCategory: nil
            )
            List {
                Section(header: sectionHeader(title: "アラーム", isExpanded: $isAlermSettingOn)) {
                    isAlermSettingOn
                    ? ItemDigitPicker(
                        selectedDigitsValue: $selectedDigitsValue, selectedUnitsValue: $selectedUnitsValue
                    )
                    .frame(height: 100)
                    .listRowBackground(Color.clear)
                    : nil
                    isAlermSettingOn
                    ? Toggle("繰り返し", isOn: $isAlermRepeatOn)
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
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                //                    .padding(.bottom)
                    .focused($focusedField, equals: .itemName)
                Button(action: {
                    VibrationHelper().feedbackVibration()
                    let intSelectedDigitsValue = Int(selectedDigitsValue)
                    timeIntervalSinceNow = TimeHelper().calcSecondsFromString(selectedUnitsValue: selectedUnitsValue, intSelectedDigitsValue: intSelectedDigitsValue ?? 0)
                    Task {
                        do {
                            shoppingItemDocId =
                            try await ShoppingItemRepository().addShoppingItemWithDocumentId(shoppingItem: ShoppingItem(
                                name: itemName,
                                category: selectedCategory,
                                addedAt: Date(),
                                isUrlSettingOn: isUrlSettingOn,
                                customURL: itemUrl,
                                isAlermSettingOn: isAlermSettingOn,
                                isAlermRepeatOn: isAlermRepeatOn,
                                alermCycleSeconds: isAlermSettingOn ? timeIntervalSinceNow : nil,
                                alermCycleString: isAlermSettingOn ?  "\(selectedDigitsValue) \(selectedUnitsValue)" : nil
                            )
                            )
                            if (isAlermSettingOn) {
                                NotificationManager().sendIntervalNotification(
                                    shoppingItem: ShoppingItem(
                                        name: itemName,
                                        category: selectedCategory,
                                        addedAt: Date(),
                                        isUrlSettingOn: isUrlSettingOn,
                                        customURL: itemUrl,
                                        isAlermSettingOn: isAlermSettingOn,
                                        isAlermRepeatOn: isAlermRepeatOn,
                                        alermCycleSeconds: isAlermSettingOn ? timeIntervalSinceNow : nil,
                                        alermCycleString: isAlermSettingOn ? "\(selectedDigitsValue) \(selectedUnitsValue)" : nil
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
                }) {
                    Text("追加")
                }
            }.padding(.horizontal)
//            Spacer()
        }.onAppear {
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

//struct AddItemView_Previews: PreviewProvider {
//    @State static var isShowSheet = true
//    static var previews: some View {
//        AddItemView(isShowSheet: $isShowSheet)
//    }
//}

