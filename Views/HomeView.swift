//
//  HomeView.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/04.
//

//line.horizontal.3

import SwiftUI

struct HomeView: View {
    enum Field: Hashable {
        case itemName
    }
    @ObservedObject private var shoppingItemRepository = ShoppingItemRepository()
    @ObservedObject var userDefaultsHelper = UserDefaultsHelper()
//    @State private var currentDarkModeOn: Bool = false
    @State private var categories: [String] = []
    @FocusState private var focusedField: Field?
    @State private var itemName = ""
    @State private var showingMenu: Bool = false
    @State private var isShowSheet: Bool = false
    @State private var isShowSetting: Bool = false
    @State private var existCategoryList: [Category] = []
    var body: some View {
        NavigationStack {
                VStack(alignment: .leading) {
                    ItemView()
                }
                .navigationBarTitle("ホーム")
                .navigationViewStyle(StackNavigationViewStyle())

            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    Button(action: {
                        isShowSetting.toggle()
                    }) {
                        Image(systemName: "gearshape")
                            .foregroundColor(Color.foreground)
                    }
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    Button(action: {
                        isShowSheet.toggle()
                    }) {
                        Image(systemName:"plus")
                            .foregroundColor(Color.foreground)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $isShowSheet) {
            AddItemView(isShowSheet: $isShowSheet)
        }
        .fullScreenCover(isPresented: $isShowSetting) {
            SettingView()
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
