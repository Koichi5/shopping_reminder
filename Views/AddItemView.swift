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
    @State private var selectedUnitsValue = "時間"
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
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    isShowSheet = false
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(Color.foreground)
                }.padding()
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach (categoryItemList) { categoryItem in
                        Text(categoryItem.category.name)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .foregroundColor(categoryItem.isSelected ? .white : categoryItem.category.color.colorData)
                            .background(categoryItem.isSelected ? categoryItem.category.color.colorData : Color.background)
                            .cornerRadius(40)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(categoryItem.category.color.colorData, lineWidth: 1.5)
                            ).onTapGesture {
                                categoryItemList.indices.forEach { index in
                                    categoryItemList[index].isSelected = categoryItemList[index].id == categoryItem.id
                                    if (categoryItemList[index].isSelected) {
                                        selectedCategory = categoryItem.category
                                        print("selected: \(selectedCategory)")
                                    }
                                }
                                VibrationHelper().feedbackVibration()
                            }
                    }
                }
                .padding(.vertical, 10)
                .padding(.leading)
            }
            List {
                Section(header: sectionHeader(title: "アラーム", isExpanded: $isAlermSettingOn)) {
//                    Toggle("アラーム設定", isOn: $isAlermSettingOn).padding(.horizontal)
                    isAlermSettingOn ?
    //                VStack {
                        //                HStack (alignment: .center){
                        //                    Text("周期")
                        //                    Spacer()
                        //                    ItemDigitPicker(
                        //                        selectedDigitsValue: $selectedDigitsValue, selectedUnitsValue: $selectedUnitsValue
                        //                    )
                        //                }
                        ItemDigitPicker(
                            selectedDigitsValue: $selectedDigitsValue, selectedUnitsValue: $selectedUnitsValue
                        )
                        .frame(height: 100)
                        .listRowBackground(Color.clear)
                    : nil
                        //                .padding(.horizontal)
                        //                .opacity(isAlermSettingOn ? 1 : 0)
                        //                .frame(height: isAlermSettingOn ? 70 : 0)
                    isAlermSettingOn ?
                    Toggle("繰り返し", isOn: $isAlermRepeatOn)
                        .listRowBackground(Color.clear)
                        //                    .opacity(isAlermSettingOn ? 1 : 0)
                        //                    .frame(height: isAlermSettingOn ? 30 : 0)
                        //                    .padding(.horizontal)
                        //                    .padding(.bottom)
    //                }
                        .padding(.horizontal) : nil
    //                .opacity(isAlermSettingOn ? 1 : 0)
    //                .frame(height: isAlermSettingOn ? 70 : 0) : nil
                }
                Section(header: sectionHeader(title: "URLから買い物", isExpanded: $isUrlSettingOn)) {
//                    Toggle("買い物URL設定", isOn: $isUrlSettingOn).padding(.horizontal)
                    isUrlSettingOn ?
    //                HStack (alignment: .center){
    //                    Text("買い物URL")
    //                    Spacer()
                        TextField("URL", text: $itemUrl)
                        .listRowBackground(Color.clear)
    //                        .textFieldStyle(RoundedBorderTextFieldStyle())
    //                }
                    .padding(.horizontal)
                    .padding(.bottom)
    //                .opacity(isUrlSettingOn ? 1 : 0)
                    .frame(height: isUrlSettingOn ? 40 : 0)
                    : nil
                }
            }.listStyle(.plain)
                HStack(alignment: .center) {
                    TextField("アイテム名", text: $itemName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    //                    .padding(.bottom)
                        .focused($focusedField, equals: .itemName)
                    Button(action: {
                        let intSelectedDigitsValue = Int(selectedDigitsValue)
                        VibrationHelper().feedbackVibration()
                        if (selectedUnitsValue == "時間") {
                            timeIntervalSinceNow = (intSelectedDigitsValue ?? 0) * 3600
                        } else if (selectedUnitsValue == "日") {
                            timeIntervalSinceNow = (intSelectedDigitsValue ?? 0) * 86400
                        } else if (selectedUnitsValue == "週間") {
                            timeIntervalSinceNow = (intSelectedDigitsValue ?? 0) * 604800
                        } else if (selectedUnitsValue == "ヶ月") {
                            timeIntervalSinceNow = (intSelectedDigitsValue ?? 0) * 2592000
                        } else {
                            print("selected units value is incorrect")
                        }
                        Task {
                            do {
                                shoppingItemDocId =
                                try await ShoppingItemRepository().addShoppingItemWithDocumentId(shoppingItem: ShoppingItem(
                                    name: itemName,
                                    category: selectedCategory,
                                    addedAt: Date(),
                                    isAlermRepeatOn: isAlermRepeatOn,
                                    alermCycleSeconds: isAlermSettingOn ? timeIntervalSinceNow : nil,
                                    alermCycleString: "\(selectedDigitsValue)\(selectedUnitsValue)",
                                    customURL: itemUrl
                                )
                                )
                                if (isAlermSettingOn) {
                                    NotificationManager().sendIntervalNotification(
                                        shoppingItem: ShoppingItem(
                                            name: itemName,
                                            category: selectedCategory,
                                            addedAt: Date(),
                                            isAlermRepeatOn: isAlermRepeatOn,
                                            alermCycleSeconds: 61,
                                            alermCycleString: "\(selectedDigitsValue)\(selectedUnitsValue)",
                                            customURL: itemUrl
                                        ),
                                        shoppingItemDocId: shoppingItemDocId
                                    )
                                }
                                NotificationManager().fetchAllRegisteredNotifications()
                                
                            } catch {
                                print("error occured while adding shopping item: \(error)")
                            }
                        }
                        //                    for shoppingItem in shoppingItemList {
                        //                        if let categoryName = shoppingItem.category?.name {
                        //                            if shoppingItemDict[categoryName] == nil {
                        //                                shoppingItemDict[categoryName] = [shoppingItem]
                        //                            } else {
                        //                                shoppingItemDict[categoryName]?.append(shoppingItem)
                        //                            }
                        //                        }
                        //                    }
                        //                    if(!shoppingItemDict.contains(where: shoppingItemDict[categoryName] == selectedCategory.name)) {
                        //
                        //                    }
                        //                    if (!existCategoryList.contains(where: {$0.name == selectedCategory.name})) {
                        //                        existCategoryList.append(selectedCategory)
                        //                        print("existCategoryList: \(existCategoryList)")
                        //                    }
                        isShowSheet = false
                    }) {
                        Text("追加")
                    }
                }.padding(.horizontal)
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

