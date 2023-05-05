//
//  AddItemView.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/05.
//

import SwiftUI

struct AddItemView: View {
    enum Field: Hashable {
        case text
    }
    @FocusState private var focusedField: Field?
    @Binding var isShowSheet: Bool
    @State private var inputText = ""
    @State private var categoryList: [Category] = []
    //    @ObservedObject var keyboardHelper = KeyboardHelper()
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                
            }
            TextField("Item Name", text: $inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            //                .offset(y: -self.keyboardHelper.keyboardHeight)
                .padding()
                .focused($focusedField, equals: .text)
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
            .onAppear() {
                // 画面を表示してから0.5秒後にキーボードを表示
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                    focusedField = .text
                }
            }
        }.onAppear {
            Task {
                do {
                    categoryList = try await CategoryRepository().fetchCategories() ?? []
                    print("onAppear categoryList[0].color: \(categoryList[0].color)")
                    print("onAppear categoryList[1].name: \(categoryList[1].name)")
                } catch {
                    print(error)
                }
            }
        }
    }
}
