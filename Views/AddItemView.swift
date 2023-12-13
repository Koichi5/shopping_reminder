//
//  AddItemView.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/05.
//

import SwiftUI
import CoreLocation

struct AddItemView: View {
    enum Field: Hashable {
        case itemName
    }
    @ObservedObject var userDefaultsHelper = UserDefaultsHelper()
    @ObservedObject var locationManager = LocationManager()
    @Binding var isShowSheet: Bool
    @State private var itemName = ""
    @State private var itemUrl = ""
    @State private var itemMemo = ""
    @State private var categoryList: [Category] = []
    @State private var categoryItemList: [CategoryItem] = []
    @State private var selectedCategory: Category? = nil
    @State private var selectedDigitsValue = "1"
    @State private var selectedUnitsValue = "時間ごと"
    @State private var timeIntervalSinceNow = 0
    @State private var isAlermSettingOn = false
    @State private var isTimeAlermSettingOn = false
    @State private var isLocationAlermSettingOn = false
    @State private var isUrlSettingOn = false
    @State private var isDetailSettingOn = false
    @State private var isAlermRepeatOn = false
    @State private var shoppingItemDocId = ""
    @State var screen: CGSize!
    @State private var isSidebarOpen = false
    @State private var isNameNilAlertPresented = false
    @State private var isCategoryNilAlertPresented = false
    @State private var isLocationAlermScreenPresented = false
    @State private var pinCoordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    
    var body: some View {
        VStack {
            ZStack {
                Text("アイテムの追加")
                    .font(.roundedFont())
                HStack {
                    Spacer()
                    Button(action: {
                        isShowSheet = false
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(Color.foreground)
                    }.padding()
                }
            }
            .padding(.vertical)
            CategoryItemList(
                categoryItemList: $categoryItemList,
                selectedCategory: $selectedCategory
            )
            List {
                Section(header: sectionHeader(title: "メモ", isExpanded: $isDetailSettingOn)) {
                    if isDetailSettingOn {
                        if #available(iOS 16.0, *) {
                            TextField("メモ", text: $itemMemo, axis: .vertical)
                                .padding(.horizontal)
                                .padding(.bottom, 30)
                        } else {
                            TextField("メモ", text: $itemMemo)
                                .padding(.horizontal)
                                .padding(.bottom, 30)
                        }
                    }
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
                        )
                        .frame(height: 100)
                    }
                    if isTimeAlermSettingOn && isAlermSettingOn {
                        Toggle(isOn: $isAlermRepeatOn) {
                            Text("繰り返し")
                                .font(.roundedFont())
                                .foregroundColor(Color.gray)
                        }
                        .padding(.horizontal)
                    }
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
                    }
                }
                Section(header: sectionHeader(title: "URLから買い物", isExpanded: $isUrlSettingOn)) {
                    if isUrlSettingOn {
                        TextField("URL", text: $itemUrl)
                            .padding(.horizontal)
                    }
                }
            }
            HStack(alignment: .center) {
                    TextField("アイテム名", text: $itemName)
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0))
                                .stroke(Color.foreground, lineWidth: 1.0)
                        )
                
                Button(action: {
                    if (itemName != "") {
                        if (selectedCategory != nil) {
                            VibrationHelper().feedbackVibration()
                            let intSelectedDigitsValue = Int(selectedDigitsValue)
                            timeIntervalSinceNow = TimeHelper().calcSecondsFromString(selectedUnitsValue: selectedUnitsValue, intSelectedDigitsValue: intSelectedDigitsValue ?? 0)
                            Task {
                                do {
                                    shoppingItemDocId =
                                    try await ShoppingItemRepository().addShoppingItemWithDocumentId(shoppingItem: ShoppingItem(
                                        name: itemName,
                                        category: selectedCategory!,
                                        addedAt: Date(),
                                        isUrlSettingOn: isUrlSettingOn,
                                        customURL: itemUrl,
                                        isAlermSettingOn: isAlermSettingOn,
                                        isAlermRepeatOn: isAlermRepeatOn,
                                        isDetailSettingOn: isDetailSettingOn,
                                        alermCycleSeconds: isAlermSettingOn ? timeIntervalSinceNow : nil,
                                        alermCycleString: isAlermSettingOn ?  "\(selectedDigitsValue) \(selectedUnitsValue)" : nil,
                                        memo: itemMemo,
                                        latitude: pinCoordinate.latitude,
                                        longitude: pinCoordinate.longitude
                                    )
                                    )
                                    if (isAlermSettingOn && isTimeAlermSettingOn) {
                                        NotificationManager().sendIntervalNotification(
                                            shoppingItem: ShoppingItem(
                                                name: itemName,
                                                category: selectedCategory!,
                                                addedAt: Date(),
                                                isUrlSettingOn: isUrlSettingOn,
                                                customURL: itemUrl,
                                                isAlermSettingOn: isAlermSettingOn,
                                                isAlermRepeatOn: isAlermRepeatOn,
                                                isDetailSettingOn: isDetailSettingOn,
                                                alermCycleSeconds: isAlermSettingOn ? timeIntervalSinceNow : nil,
                                                alermCycleString: isAlermSettingOn ? "\(selectedDigitsValue) \(selectedUnitsValue)" : nil,
                                                memo: itemMemo,
                                                latitude: pinCoordinate.latitude,
                                                longitude: pinCoordinate.longitude
                                            ),
                                            shoppingItemDocId: shoppingItemDocId
                                        )
                                    } else if (isAlermSettingOn && isLocationAlermSettingOn) {
                                        NotificationManager().sendLocationNotification(itemName: itemName, notificationLatitude: pinCoordinate.latitude, notificationLongitude: pinCoordinate.longitude, shoppingItemDocId: shoppingItemDocId)
                                    }
                                    NotificationManager().fetchAllRegisteredNotifications()
                                } catch {
                                    print("error occured while adding shopping item: \(error)")
                                }
                            }
                            isShowSheet = false
                        } else {
                            VibrationHelper().errorVibration()
                            isCategoryNilAlertPresented = true
                        }
                    } else {
                        VibrationHelper().errorVibration()
                        isNameNilAlertPresented = true
                    }
                }) {
                    Text("追加")
                        .font(.roundedFont())
                        .padding(10)
                        .foregroundColor(Color.white)
                        .background(itemName == ""
                                    ? Color.gray.cornerRadius(10)
                                    : Color.blue.cornerRadius(10)
                        )
                }
                .padding(.horizontal, 10)
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
        .onAppear {
            Task {
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
        .alert (isPresented: $isNameNilAlertPresented) {
            Alert(title: Text("アイテムの名前が指定されていません"))
        }
        .alert (isPresented: $isCategoryNilAlertPresented) {
            Alert(title: Text("アイテムのカテゴリが指定されていません"))
        }
        .fullScreenCover(isPresented: $isLocationAlermScreenPresented) {
            MapView(pinCoordinate: $pinCoordinate)
        }
    }
}

extension AddItemView {
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

private extension View {
    @ViewBuilder
    func ultraThinMaterialIfAvailable() -> some View {
        if #available(iOS 16.4, *) {
            presentationBackground(Material.thick)
        } else {
            self
        }
    }
}

