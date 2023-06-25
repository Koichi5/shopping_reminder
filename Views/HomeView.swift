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
    @ObservedObject var userDefaultsHelper = UserDefaultsHelper()
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
                }.padding(.horizontal) .frame(maxWidth: .infinity)
            .navigationBarTitle("Home")
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
                        Image(systemName: "plus").foregroundColor(Color.foreground)
                    }
                }
            }
        }
        .sheet(isPresented: $isShowSheet) {
            AddItemView(isShowSheet: $isShowSheet)
        }
        .fullScreenCover(isPresented: $isShowSetting) {
            SettingView()
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .preferredColorScheme(userDefaultsHelper.isDarkModeOn ? .dark : .light)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
