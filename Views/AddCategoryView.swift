//
//  AddCategoryView.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/12/11.
//

import SwiftUI

struct AddCategoryView: View {
    @State var name: String = ""
    @State var categoryColor: CategoryColor = CategoryColor.black
    @State var categoryStyle: CategoryStyle = CategoryStyle(color: CategoryColor.black)
    private func addCategory(category: Category) async throws {
        try await CategoryRepository().addCategory(category: category)
    }
    @State private var bgColor =
        Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)
    
    var body: some View {
        TextField("カテゴリ名", text: $name)
            .textFieldStyle(.roundedBorder)
            .padding()
        ColorPicker("Alignment Guides", selection: $bgColor)
        Button(action: {
            Task {
                try await addCategory(category: Category(name: name, color: categoryColor, style: categoryStyle))
            }
        }) {
            Text("カテゴリー追加")
        }
    }
}

//#Preview {
//    AddCategoryView()
//}
