//
//  EditItemView.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/13.
//

import SwiftUI
import Foundation
import CoreLocation

struct EditItemView: View {
    @ObservedObject var userDefaultsHelper = UserDefaultsHelper()
    @ObservedObject var locationManager = LocationManager()
    @Binding var isShowSheet: Bool
    @State private var shoppingItemId: String = ""
    @State private var shoppingItemName = ""
    @State private var itemUrl = ""
    @State private var itemMemo = ""
    @State private var isDetailSettingOn = false
    @State private var categoryList: [Category] = []
    @State private var categoryItemList: [CategoryItem] = []
    @State private var selectedCategory: Category = Category(name: "その他", color: CategoryColor.gray, style: CategoryStyle(color: CategoryColor.gray))
    @State private var selectedDigitsValue = "1"
    @State private var selectedUnitsValue = "時間ごと"
    @State private var timeIntervalSinceNow = 0
    @State private var isAlermSettingOn = false
    @State private var isTimeAlermSettingOn = false
    @State private var isLocationAlermSettingOn = false
    @State private var isUrlSettingOn = false
    @State private var isAlermRepeatOn = false
    @State private var isShowingDeleteAlert = false
    @State private var shoppingItemDocId = ""
    @State private var isLocationAlermScreenPresented = false
    @State private var pinCoordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    let shoppingItem: ShoppingItem
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                VStack {
                    TextField("", text: $shoppingItemName)
                        .onAppear {
                            shoppingItemName = shoppingItem.name
                        }
                        .font(.largeTitle.bold())
                        .padding(.horizontal)
                    Spacer()
                    List {
                        Section(header: sectionHeader(title: "メモ", isExpanded: $isDetailSettingOn)) {
                            if isDetailSettingOn {
                                TextField(
                                    "メモ",
                                    text: $itemMemo, axis: .vertical)
                                .padding(.horizontal)
                                .padding(.bottom, 30)
                            }
                        }
                        .onAppear {
                            isDetailSettingOn = shoppingItem.isDetailSettingOn
                            itemMemo = shoppingItem.memo ?? ""
                        }
                        Section(header: sectionHeader(title: "アラーム", isExpanded: $isAlermSettingOn)) {
                            if isAlermSettingOn {
                                Button(action: { isTimeAlermSettingOn.toggle() }) {
                                    VStack {
                                        HStack {
                                            Text("時間で設定")
                                            Spacer()
                                            Image(systemName: isTimeAlermSettingOn ? "chevron.up" : "chevron.down")
                                        }
                                    }
                                }
                                .foregroundColor(Color.gray)
                                .padding(.leading)
                            }
                            if isTimeAlermSettingOn && isAlermSettingOn {
                                ItemDigitPicker(
                                    selectedDigitsValue: $selectedDigitsValue, selectedUnitsValue: $selectedUnitsValue
                                ).onAppear {
                                    let arr:[String] = shoppingItem.alermCycleString?.components(separatedBy: " ") ?? ["1", "時間ごと"]
                                    selectedDigitsValue = arr[0]
                                    selectedUnitsValue = arr[1]
                                }
                                .frame(height: 100)
                            }
                            if isTimeAlermSettingOn && isAlermSettingOn {
                                Toggle("繰り返し", isOn: $isAlermRepeatOn)
                                    .foregroundColor(Color.gray)
                                
                                .padding(.horizontal)}
                            if isAlermSettingOn {
                                Button(action: {
                                    if (
                                        locationManager.authorizationStatus == CLAuthorizationStatus.denied || locationManager.authorizationStatus == CLAuthorizationStatus.notDetermined || locationManager.authorizationStatus == CLAuthorizationStatus.restricted
                                    ) {
                                        locationManager.requestPremission()
                                    }
                                    isLocationAlermScreenPresented = true
                                }) {
                                    VStack {
                                        HStack {
                                            Text("場所を設定")
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                        }
                                    }
                                }
                                .foregroundColor(Color.gray)
                                .padding(.leading)
                                .onAppear {
                                    pinCoordinate = CLLocationCoordinate2D(latitude: shoppingItem.latitude ?? 0.0, longitude: shoppingItem.longitude ?? 0.0)
                                }
                            }
                        }
                        .onAppear {
                            isAlermSettingOn = shoppingItem.isAlermSettingOn
                        }
                        Section(header: sectionHeader(title: "URLから買い物", isExpanded: $isUrlSettingOn)) {
                            if isUrlSettingOn {
                                TextField("URL", text: $itemUrl)
                                    .padding(.horizontal)
                                    .padding(.bottom)
                                    .frame(height: isUrlSettingOn ? 40 : 0)
                            }
                        }
                        .onAppear {
                            isUrlSettingOn = shoppingItem.customURL != ""
                            itemUrl = shoppingItem.customURL ?? ""
                        }
                    }
                    ButtonHelper(
                        buttonText: "変更",
                        buttonAction: {
                            VibrationHelper().feedbackVibration()
                            let intSelectedDigitsValue = Int(selectedDigitsValue)
                            timeIntervalSinceNow = TimeHelper()
                                .calcSecondsFromString(
                                    selectedUnitsValue: selectedUnitsValue,
                                    intSelectedDigitsValue: intSelectedDigitsValue ?? 0)
                            Task {
                                do {
                                    try await ShoppingItemRepository().updateShoppingItem(shoppingItem: ShoppingItem(
                                        name: shoppingItemName,
                                        category: selectedCategory,
                                        addedAt: Date(),
                                        isUrlSettingOn: isUrlSettingOn,
                                        customURL: itemUrl,
                                        isAlermSettingOn: isAlermSettingOn,
                                        isAlermRepeatOn: isAlermRepeatOn,
                                        isDetailSettingOn: isDetailSettingOn,
                                        alermCycleSeconds: isAlermSettingOn ? timeIntervalSinceNow : nil,
                                        alermCycleString: isAlermSettingOn ?  "\(selectedDigitsValue)\(selectedUnitsValue)" : nil,
                                        memo: itemMemo,
                                        latitude: pinCoordinate.latitude,
                                        longitude: pinCoordinate.longitude
                                    ),
                                                                                          shoppingItemId: shoppingItem.id ?? "")
                                    if (isAlermSettingOn && isTimeAlermSettingOn) {
                                        NotificationManager().sendIntervalNotification(
                                            shoppingItem: ShoppingItem(
                                                name: shoppingItemName,
                                                category: selectedCategory,
                                                addedAt: Date(),
                                                isUrlSettingOn: isUrlSettingOn,
                                                customURL: itemUrl,
                                                isAlermSettingOn: isAlermSettingOn,
                                                isAlermRepeatOn: isAlermRepeatOn,
                                                isDetailSettingOn: isDetailSettingOn,
                                                alermCycleSeconds: isAlermSettingOn ? timeIntervalSinceNow : nil,
                                                alermCycleString: isAlermSettingOn ? "\(selectedDigitsValue)\(selectedUnitsValue)" : nil,
                                                memo: itemMemo,
                                                latitude: pinCoordinate.latitude,
                                                longitude: pinCoordinate.longitude
                                            ),
                                            shoppingItemDocId: shoppingItemDocId
                                        )
                                    } else if (isAlermSettingOn && isLocationAlermSettingOn) {
                                        NotificationManager().deleteNotification(shoppingItemIndentifier: [shoppingItemDocId])
                                        NotificationManager().sendLocationNotification(itemName: shoppingItemName, notificationLatitude: pinCoordinate.latitude, notificationLongitude: pinCoordinate.longitude, shoppingItemDocId: shoppingItemDocId)
                                    }
                                    NotificationManager().fetchAllRegisteredNotifications()
                                } catch {
                                    print("error occured while adding shopping item: \(error)")
                                }
                            }
                            isShowSheet = false
                        },
                        foregroundColor: Color.white,
                        backgroundColor: Color.blue,
                        buttonTextIsBold: nil,
                        buttonWidth: nil,
                        buttonHeight: nil,
                        buttonTextFontSize: nil
                    )
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                .toolbar {
                    ToolbarItemGroup (placement: .confirmationAction) {
                        Spacer()
                        ShareLink(
                            item: "\(shoppingItem.name)を買い忘れないようにしよう！"
                        ) {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(Color.foreground)
                        }
                        Button(action: { isShowingDeleteAlert = true}) {
                            Image(systemName: "trash").foregroundColor(Color.foreground)
                        }
                        .alert("このアイテムを削除しますか？", isPresented: $isShowingDeleteAlert) {
                            Button("キャンセル") {
                                isShowingDeleteAlert = false
                            }
                            //                        NavigationLink(destination: HomeView()) {
                            Button("削除") {
                                print("secondary button action fired")
                                NotificationManager().deleteNotification(shoppingItemIndentifier: [shoppingItem.id ?? ""])
                                Task {
                                    do {
                                        try await ShoppingItemRepository().deleteShoppingItem(shoppingItem: shoppingItem)
                                        
                                    } catch {
                                        print(error)
                                    }
                                }
                                NotificationManager().fetchAllRegisteredNotifications()
                            }
                        }
                    }
                }
                .fullScreenCover(isPresented: $isLocationAlermScreenPresented) {
                    MapView(pinCoordinate: $pinCoordinate)
                }
            }
            .task {
                do {
                    categoryList = try await CategoryRepository().fetchCategories()
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

extension EditItemView {
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

//struct EditItemView_Previews: PreviewProvider {
//    @State private var isAlermSettingOn: Bool = true
//    static var previews: some View {
//        EditItemView(
//            shoppingItem: ShoppingItem(
//                name: "キッチンペーパー",
//                category: Category(
//                    name: "clothes",
//                    color: CategoryColor.red
//                ),
//                addedAt: Date(),
//                isUrlSettingOn: false,
//                customURL: "https://swappli.com/switcheditmode/",
//                isAlermSettingOn: true,
//                isAlermRepeatOn: false,
//                alermCycleSeconds: 100,
//                alermCycleString: "10日"
//            ))
//    }
//}
