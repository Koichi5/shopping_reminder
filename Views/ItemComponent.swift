//
//  ShoppingItemComponent.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/07.
//

import SwiftUI

struct ItemComponent: View {
    let shoppingItem: ShoppingItem
    @State private var isDeleted = false
    @State private var isEditPresented = false
    @State var isUrlLinkPresented = false
    @State var isShowItemDetail = false
    var body: some View {
        NavigationStack {
            HStack {
                Circle()
                    .fill(shoppingItem.category.color.colorData)
                    .frame(width: 10, height: 10)
                    .padding(.horizontal)
                Text("\(shoppingItem.name)")
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
            .background(Color.itemCard)
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
//            .onAppear {
//                print("shopping item id in shopping item component is : \(shoppingItem.id)")
//            }
//            .onTapGesture {
//                isEditPresented.toggle()
//                print("shoppingItem id on component: \(shoppingItem.id)")
//            }
//            .onLongPressGesture (
//                minimumDuration: 0.5, maximumDistance: 10
//            ) {
//                print("long press")
//                isEditPresented.toggle()
//            }
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
//            expirationDate: Date(),
            alermCycleSeconds: 100,
            alermCycleString: "",
            memo: ""
//            id: nil
        ))
    }
}
