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
    @State private var itemName = ""
    @State private var itemUrl = ""
    @State private var categoryList: [Category] = []
    @State private var categoryItemList: [CategoryItem] = []
    @State private var selectedCategory: Category = Category(name: "", color: CategoryColor.black)
    @State private var selectedDigitsValue = "1"
    @State private var selectedUnitsValue = "時間"
    @State private var timeIntervalSinceNow = 0
    @State private var isAlermSettingOn = false
    @State private var isUrlSettingOn = false
    @State private var isAlermRepeatOn = false
    @State private var shoppingItemId = ""
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
            Toggle("アラーム設定", isOn: $isAlermSettingOn).padding(.horizontal)
            VStack {
                HStack (alignment: .center){
                    Text("アラーム周期")
                    Spacer()
                    ItemDigitPicker(
                        selectedDigitsValue: $selectedDigitsValue, selectedUnitsValue: $selectedUnitsValue
                    )
                }
                .padding(.horizontal)
                .opacity(isAlermSettingOn ? 1 : 0)
                .frame(height: isAlermSettingOn ? 90 : 0)
                Toggle("繰り返し", isOn: $isAlermRepeatOn).padding(.horizontal)
                    .opacity(isAlermSettingOn ? 1 : 0)
                    .frame(height: isAlermSettingOn ? 30 : 0)
                    .padding(.horizontal)
                    .padding(.bottom)
            }
            Toggle("買い物URL設定", isOn: $isUrlSettingOn).padding(.horizontal)
            HStack (alignment: .center){
                Text("買い物URL")
                Spacer()
                TextField("URL", text: $itemUrl)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal)
            .padding(.bottom)
            .opacity(isUrlSettingOn ? 1 : 0)
            .frame(height: isUrlSettingOn ? 90 : 0)
            HStack(alignment: .center) {
                TextField("Item Name", text: $itemName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .padding(.bottom)
                    .focused($focusedField, equals: .itemName)
                Button(action: {
                    Task {
                        do {
                            shoppingItemId = try await ShoppingItemRepository().addShoppingItemWithDocumentId(shoppingItem: ShoppingItem(
                                name: itemName,
                                category: selectedCategory,
                                addedAt: Date(),
//                                expirationDate: isAlermSettingOn ? Date(timeIntervalSinceNow: TimeInterval(timeIntervalSinceNow)) : nil
                                isAlermRepeatOn: isAlermRepeatOn,
                                alermCycleSeconds: isAlermSettingOn ? timeIntervalSinceNow : nil,
                                alermCycleString: "\(selectedDigitsValue)\(selectedUnitsValue)",
                                customURL: itemUrl
                            )
                            )
                            if (isAlermSettingOn) {
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
                                if(shoppingItemId == "") {
                                    print("shopping item id is nil")
                                } else {
                                    NotificationManager().sendIntervalNotification(
                                        shoppingItem: ShoppingItem(
                                            name: itemName,
                                            category: selectedCategory,
                                            addedAt: Date(),
                                            isAlermRepeatOn: isAlermRepeatOn,
                                            alermCycleSeconds: 10,
                                            alermCycleString: "\(selectedDigitsValue)\(selectedUnitsValue)",
                                            customURL: itemUrl
                                        ),
                                        shoppingItemId: shoppingItemId
                                    )
                                }
                                NotificationManager().fetchAllRegisteredNotifications()
                            }
                        } catch {
                            print("error occured while adding shopping item: \(error)")
                        }
                    }
                    isShowSheet = false
                }) {
                    Text("追加")
                }.padding()
            }
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                focusedField = .itemName
            }
            Task {
                do {
                    categoryList = try await CategoryRepository().fetchCategories() ?? []
                    print("onAppear categoryList[0].color: \(categoryList[0].color)")
                    print("onAppear categoryList[1].name: \(categoryList[1].name)")
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

//struct AddItemView_Previews: PreviewProvider {
//    @State static var isShowSheet = true
//    static var previews: some View {
//        AddItemView(isShowSheet: $isShowSheet)
//    }
//}
