//
//  ShoppingItemComponent.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/07.
//

import SwiftUI

struct ItemComponent: View {
    let shoppingItem: ShoppingItem
    @ObservedObject var userDefaultsHelper = UserDefaultsHelper()
    @State private var isDeleted = false
    @State private var isEditPresented = false
    @State var isUrlLinkPresented = false
    @State var isShowItemDetail = false
    var body: some View {
//        Navigation View にすると Card のビューがおかしくなるので注意
        NavigationStack {
            HStack {
                Circle()
                    .fill(shoppingItem.category.color.colorData)
                    .frame(width: 10, height: 10)
                    .padding(.horizontal)
                Text("\(shoppingItem.name)")
                    .font(.roundedFont())
                Spacer()
                shoppingItem.customURL == "" ? nil :
                Menu {
                    Button(action: {
                        print("is url link presented")
                        if let url = URL(string: shoppingItem.customURL ?? "") {
                            if(shoppingItem.customURL == "") {
                                print("custom url is nil")
                            }
                            UIApplication.shared.open(url, options: [.universalLinksOnly: false], completionHandler: { completed in
                                print(completed)
                            })
                        }
                    }) {
                        Text("URLを開く")
                    }
                } label: {
                    Image(systemName: "link")
                        .foregroundColor(Color.foreground)
                }
                Button(action: {
                    isEditPresented.toggle()
                }) {
                    Image(systemName: "pencil")
                        .foregroundColor(Color.foreground)
                }
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(shoppingItem.category.color.colorData, lineWidth: 1.5)
            )
            .navigationDestination(isPresented: $isEditPresented) {
                EditItemView(isShowSheet: $isEditPresented, shoppingItem: shoppingItem)
            }
            .onLongPressGesture {
                //                self.isShowItemDetail.toggle()
            }
            .contextMenu {
                Group {
                    shoppingItem.memo == nil || shoppingItem.memo == "" ? Text("メモは記録されていません") : Text(shoppingItem.memo!)
                }
            }
        }
    }
}

struct ItemComponent_Previews: PreviewProvider {
    static var previews: some View {
        ItemComponent(shoppingItem: ShoppingItem(
            name: "name",
            category: Category(name: "category", color: CategoryColor.blue, style: CategoryStyle(color: CategoryColor.blue)),
            addedAt: Date(),
            isUrlSettingOn: false,
            customURL: "",
            isAlermSettingOn: true,
            isAlermRepeatOn: false,
            isDetailSettingOn: false,
            alermCycleSeconds: 100,
            alermCycleString: "",
            memo: ""
        ))
    }
}
