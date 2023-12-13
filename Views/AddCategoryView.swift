//
//  AddCategoryView.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/12/11.
//

import SwiftUI

struct AddCategoryView: View {
    @State var name: String = ""
    @State var selectedColor: CategoryColor = CategoryColor.black
    @State var isCategoryColorSettingOn: Bool = false
    @State var isHomeViewPresented: Bool = false
    private func addCategory(category: Category) async throws {
        try await CategoryRepository().addCategory(category: category)
    }
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        VStack {
            TextField("カテゴリ名", text: $name)
                .font(.largeTitle.bold())
                .padding()
            List {
                Section(header: sectionHeader(title: "カラー", isExpanded: $isCategoryColorSettingOn)) {
                    if isCategoryColorSettingOn {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(CategoryColor.allCases, id: \.self) { color in
                                color.colorData
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                                            .stroke(selectedColor == color ? Color.logo : Color.clear, lineWidth: 4)
                                    )
                                    .onTapGesture {
                                        selectedColor = color
                                    }
                            }
                        }
                    }
                }
            }
            Button(action: {
                Task {
                    try await addCategory(category: Category(name: name, color: selectedColor, style: CategoryStyle(color: selectedColor)))
                }
                isHomeViewPresented = true
            }) {
                Text("カテゴリー追加")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .foregroundColor(Color.white)
                    .background(Color.blue.cornerRadius(10))
            }
            .padding()
        }
        .fullScreenCover(isPresented: $isHomeViewPresented) {
            HomeView()
        }
    }
}

extension AddCategoryView {
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

//#Preview {
//    AddCategoryView()
//}
