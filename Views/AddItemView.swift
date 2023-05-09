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
    @State private var categoryList: [Category] = []
    @State private var categoryItemList: [CategoryItem] = []
    @State private var selectedCategory: Category = Category(name: "", color: CategoryColor.black)
    @State private var selectedDigitsValue = "1"
    @State private var selectedUnitsValue = "時間"
    @State private var timeIntervalSinceNow = 0
    //    @State private var isSelected = false
    //    @State private var selectedValue: Category?
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
                        //                    ForEach(categoryItemList) { categoryItem in
                        //                        Button(action: {
                        //                            categoryItemList.indices.forEach { index in
                        //                                categoryItemList[index].isSelected = categoryItemList[index].id == categoryItem.id
                        //                            }
                        //                        }) {
                        //                            Text(categoryItem.category.name)
                        //                        }
                        //                        .background(categoryItem.isSelected ? Color.blue : Color.clear)
                        //                    }
                    }
                }
                .padding(.vertical, 5)
                .padding(.leading)
            }
            ItemDigitPicker(
                selectedDigitsValue: $selectedDigitsValue, selectedUnitsValue: $selectedUnitsValue
            )
            HStack(alignment: .center) {
                TextField("Item Name", text: $itemName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                //                .offset(y: -self.keyboardHelper.keyboardHeight)
                    .padding(.horizontal)
                    .padding(.bottom)
                    .focused($focusedField, equals: .itemName)
                Button(action: {
                    let intSelectedDigitsValue = Int(selectedDigitsValue)
                    VibrationHelper().feedbackVibration()
                    if (selectedUnitsValue == "時間") {
                        timeIntervalSinceNow = intSelectedDigitsValue ?? 0 * 3600
                    } else if (selectedUnitsValue == "日") {
                        timeIntervalSinceNow = intSelectedDigitsValue ?? 0 * 86400
                    } else if (selectedUnitsValue == "週間") {
                        timeIntervalSinceNow = intSelectedDigitsValue ?? 0 * 604800
                    } else if (selectedUnitsValue == "ヶ月") {
                        timeIntervalSinceNow = intSelectedDigitsValue ?? 0 * 2592000
                    } else {
                        print("selected units value is incorrect")
                    }
                    NotificationManager().sendCalenderNotification(shoppingItem: ShoppingItem(
                        name: itemName,
                        category: selectedCategory,
                        addedAt: Date(),
                        expirationDate: Date(timeIntervalSinceNow: TimeInterval(timeIntervalSinceNow))))
                    
                    Task {
                        do {
                            try await ShoppingItemRepository().addShoppingItem(shoppingItem: ShoppingItem(
                                name: itemName,
                                category: selectedCategory,
                                addedAt: Date(),
                                expirationDate: Date(timeIntervalSinceNow: TimeInterval(timeIntervalSinceNow))
                            )
                            )
                            //                            let result = try await ShoppingItemRepository().fetchRealtimeShoppingItem()
                            //                            print(result ?? "nil")
                            //                            addusersnapshotlistener でitemsコレクションの変更を監視
                            ShoppingItemRepository().addUserSnapshotListener()
                        } catch {
                            print("error occured while adding shopping item: \(error)")
                        }
                    }
                }) {
                    Text("追加")
                }.padding()
            }
            //            Button(action: {
            //                Task {
            //                    do {
            //                        categoryList = try await CategoryRepository().fetchCategories() ?? []
            //                        print("categoryList[0].color: \(categoryList[0].color)")
            //                        print("categoryList[1].name: \(categoryList[1].name)")
            //                    } catch {
            //                        print(error)
            //                    }
            //                }
            //            }) {
            //                Text("get snapshot")
            //            }
            //                .onAppear() {
            //                    // 画面を表示してから0.1秒後にキーボードを表示
            //                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            //                        focusedField = .text
            //                    }
            //                }
            //                .onAppear {
            //                    Task {
            //                        do {
            //                            categoryList = try await CategoryRepository().fetchCategories() ?? []
            //                            print("onAppear categoryList[0].color: \(categoryList[0].color)")
            //                            print("onAppear categoryList[1].name: \(categoryList[1].name)")
            //                            for category in categoryList {
            //                                categoryItemList.append(CategoryItem(category: category))
            //                            }
            //                        } catch {
            //                            print(error)
            //                        }
            //                    }
            //                }
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
