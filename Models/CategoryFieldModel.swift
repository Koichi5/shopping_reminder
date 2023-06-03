//
//  CategoryFieldModel.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/31.
//

import SwiftUI

//struct CategoryFieldModel {
//    var text: String
//    var color: Color
//}

struct CategoryFieldRow: View {
    @Binding var category: Category
    @State private var isEditing: Bool = false
    @State private var selectedColor = Color.gray
    @State private var isColorEditing: Bool = false
    @State private var currentTask: Task<(), Never>?
    private func updateCategory(category: Category) async throws {
        try await CategoryRepository().updateCategory(category: category)
    }
    var onCommit: () -> Void
    
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
                    VStack {
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
                        ButtonHelper(buttonText: "変更", buttonAction: {
                            currentTask?.cancel()
                            currentTask = Task {
                                do {
                                    try await updateCategory(category: Category(name: category.name, color:  CategoryColor.gray))
                                } catch {
                                    print(error)
                                }
                            }
                        }, foregroundColor: Color.white, backgroundColor: selectedColor, buttonTextIsBold: nil, buttonWidth: nil, buttonHeight: nil, buttonTextFontSize: nil)
                        //                        Button(action: {
                        //                            currentTask?.cancel()
                        //                            currentTask = Task {
                        //                                do {
                        //                                    try await updateCategory(category: Category(name: category.name, color:  CategoryColor.gray))
                        //                                } catch {
                        //                                    print(error)
                        //                                }
                        //                            }
                        //                        }) {
                        //                            Text("変更")
                        //                                .fontWeight(.bold)
                        //                                .foregroundColor(Color.white)
                        //                                .background(selectedColor.cornerRadius(10))
                        //                                .frame(maxWidth: .infinity, minHeight: 48)
                        //                                .padding(.horizontal, 32)
                        //                        }
                        .onDisappear {
                            currentTask?.cancel()
                        }
                    }
                }
            TextField.init(
                "",
                text: self.$category.name,
                onEditingChanged: {_ in
                    isEditing = true
                },
                onCommit: {
                    self.onCommit()
                    isEditing = false
                }
            )
            Spacer()
            isEditing
            ? Button(action: {
                //                CategoryRepository().updateCategory(category: Category(name: self.category.name, color: color))
            }) {
                Text("変更")
            }
            : nil
        }
    }
}
