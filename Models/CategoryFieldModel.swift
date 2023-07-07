//
//  CategoryFieldModel.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/31.
//

import SwiftUI

struct CategoryFieldRow: View {
    var focusedField: FocusState<UUID?>.Binding
    @State var textfieldUUID: UUID = UUID()
    @Binding var category: Category
    @State private var isNameEditing: Bool = false
    @State private var selectedColor = Color.gray
//    @State private var isColorEditing: Bool = false
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
            TextField(
                "",
                text: self.$category.name,
                onEditingChanged: { onEditing in
                    isNameEditing = onEditing
                },
                onCommit: {
                    isNameEditing = false
                }
            )
            .focused(focusedField, equals: textfieldUUID)
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
