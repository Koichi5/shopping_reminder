//
//  CategoryFieldModel.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/31.
//

import SwiftUI

struct CategoryFieldRow: View {
    @Binding var category: Category
    @State private var isNameEditing: Bool = false
    @State private var selectedColor = Color.gray
    @State private var isColorEditing: Bool = false
    @State private var currentTask: Task<(), Never>?
    private func updateCategoryColor(categoryId: String, categoryColorNum: Int) async throws {
        try await CategoryRepository().updateCategoryColor(categoryId: categoryId, categoryColorNum: categoryColorNum)
    }
    private func updateCategoryName(categoryId: String, categoryName: String) async throws {
        try await CategoryRepository().updateCategoryName(categoryId: categoryId, categoryName: categoryName)
    }
    
    var body: some View {
        HStack {
            Circle()
                .foregroundColor(self.$category.color.wrappedValue.colorData)
                .frame(width: 10, height: 10)
                .padding(.horizontal)
                .onTapGesture {
                    isColorEditing = true
                }
                .sheet(isPresented: $isColorEditing) {
                    VStack() {
                        Text("\(category.name)カテゴリの色変更")
                        Picker("\(category.name)カテゴリの色変更", selection: $selectedColor) {
                            ForEach(colorList, id: \.self) { item in
                                HStack {
                                    Circle()
                                        .foregroundColor(item)
                                        .frame(width: 10, height: 10)
                                    Text(item.description)
                                }
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        ButtonHelper(
                            buttonText: "変更",
                            buttonAction: {
                                isColorEditing = false
                                currentTask?.cancel()
                                currentTask = Task {
                                    do {
                                        try await updateCategoryColor(categoryId: category.id ?? "", categoryColorNum: category.color.colorNum)
                                        print("category id: \(category.id)")
                                    } catch {
                                        print(error)
                                    }
                                }
                            },
                            foregroundColor: Color.white,
                            backgroundColor: selectedColor,
                            buttonTextIsBold: nil,
                            buttonWidth: nil,
                            buttonHeight: nil,
                            buttonTextFontSize: nil)
                        .onDisappear {
                            currentTask?.cancel()
                        }
                    }
                }.presentationDetents([.medium])
            TextField.init(
                "",
                text: self.$category.name,
                onEditingChanged: {_ in
                    isNameEditing = true
                },
                onCommit: {
                    isNameEditing = false
                }
            )
            Spacer()
            isNameEditing
            ? Button(action: {
                currentTask?.cancel()
                currentTask = Task {
                    do {
                        try await updateCategoryName(categoryId: category.id ?? "", categoryName: self.category.name)
                        print("category id: \(category.id)")
                    } catch {
                        print(error)
                    }
                }
                isNameEditing = false
            }) {
                Text("変更")
            }
            : nil
        }
    }
}