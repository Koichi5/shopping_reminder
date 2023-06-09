//
//  SideMenuView.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/04.
//

import SwiftUI

class MenuContent: Identifiable, ObservableObject {
    var id = UUID()
    var name: String = ""
    var image: String = ""
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}

let menuHome = MenuContent(name: "Home", image: "house.fill")
let menuProfile = MenuContent(name: "Profile", image: "person.fill")
let menuChat = MenuContent(name: "Chat", image: "message.fill")
let menuLogout = MenuContent(name: "Settings", image: "gearshape.fill")
let menuContents = [menuHome, menuProfile, menuChat, menuLogout]

struct SideMenuContentView: View {
    var menu: [MenuContent] = menuContents
    @State var menuItemSelected: MenuContent = menuContents[0]
    func selected(Menu: MenuContent) -> some View {
        switch Menu.name {
        case "Home":
            return AnyView(HomeView())
            
        case "Profile":
            return AnyView(ProfileView())
            
        case "Chat":
            return AnyView(ChatView())
            
//        case "Settings":
//            return AnyView(SettingView())
            
        default:
            return AnyView(HomeView())
        }
    }
    var body: some View {
        ZStack {
            List(menu) { menuItem in
                MenuCell(menuItem: menuItem).onTapGesture {
                    self.menuItemSelected = menuItem
                }
            }
            self.selected(Menu: menuItemSelected)
        }
    }
}

struct MenuCell: View {
    var menuItem: MenuContent = menuContents[0]
    var body: some View {
        HStack {
            Image(systemName: menuItem.image)
                .foregroundColor(
                    .gray)
            Text(menuItem.name)
                .foregroundColor(
                    .gray)
            Spacer()
        }.frame(minWidth: 200)
    }
 }
