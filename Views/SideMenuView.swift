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
let menuLogout = MenuContent(name: "Logout", image: "power")
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
            
        case "Logout":
            return AnyView(LogoutView())
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
        }.frame(minWidth: 200, maxWidth: .infinity)
    }
 }




//struct SideMenuView: View {
//    @Binding var isOpen: Bool
//    @Binding var text: String
//    let width: CGFloat = 270
//
//    var body: some View {
//        ZStack {
//            // 背景部分
//            GeometryReader { geometry in
//                EmptyView()
//            }
//            .background(Color.gray.opacity(0.3))
//            .opacity(self.isOpen ? 1.0 : 0.0)
//            .opacity(1.0)
//            .animation(.easeIn(duration: 0.25))
//            .onTapGesture {
//                self.isOpen = false
//            }
//            HStack {
//                VStack() {
//                    SideMenuContentView(
//                        topPadding: 100,
//                        systemName: "person",
//                        text: "Profile",
//                        destination: AnyView(SettingView()),
//                        bindText: $text,
//                        isOpen: $isOpen)
//                    SideMenuContentView(
//                        systemName: "bookmark",
//                        text: "Bookmark",
//                        destination: AnyView(SettingView()),
//                        bindText: $text,
//                        isOpen: $isOpen)
//                    SideMenuContentView(
//                        systemName: "gear",
//                        text: "Sttting",
//                        destination: AnyView(SettingView()),
//                        bindText: $text,
//                        isOpen: $isOpen)
//                    Spacer()
//                }
//                .frame(width: width)
//                .background(Color(UIColor.systemGray6))
//                .offset(x: self.isOpen ? 0 : -self.width)
//                .animation(.easeIn(duration: 0.25))
//                Spacer()
//            }
//        }
//    }
//}
//
//struct SideMenuContentView: View {
//    let topPadding: CGFloat
//    let systemName: String
//    let text: String
//    let destination: AnyView
////    let onTap: CGFunction
////    let items = [SettingView(), ContentView()] as [Any]
////    @State private var selectedItem: String?
//    @Binding var bindText: String
//    @Binding var isOpen: Bool
//
//    init(
//        topPadding: CGFloat = 30,
//        systemName: String,
//        text: String,
////        onTap: CGFunction,
//        destination: AnyView,
////        items: [Any],
////        selectedItem: String?,
//        bindText: Binding<String>,
//        isOpen: Binding<Bool>) {
//        self.topPadding = topPadding
//        self.systemName = systemName
//        self.text = text
//        self.destination = destination
////            self.items = items
////            self.selectedItem = selectedItem
////        self.onTap = onTap
//        self._bindText = bindText
//        self._isOpen = isOpen
//    }
//
//    var body: some View {
//        HStack {
//            Image(systemName: systemName)
//                .foregroundColor(.gray)
//                .imageScale(.large)
//                .frame(width: 32.0)
//            Text(text)
//                .foregroundColor(.gray)
//                .font(.headline)
//            Spacer()
//        }.onTapGesture {
//        }
//        .padding(.top, topPadding)
//        .padding(.leading, 32)
//        .onTapGesture {
//            self.bindText = self.text
//            self.isOpen = false
//        }
//    }
//}
//
//struct SideMenuView_Previews: PreviewProvider {
//    @State static var isOpen = true
//    @State static var text = "Hello World"
//    static var previews: some View {
//        SideMenuView(isOpen: $isOpen, text: $text)
//    }
//}
//
////struct DrawerItem: Identifiable, Hashable {
////    let id = UUID()
////    let title: String
////    let destination: AnyView
////
////    static func == (lhs: DrawerItem, rhs: DrawerItem) -> Bool {
////        return lhs.id == rhs.id
////    }
////
////    func hash(into hasher: inout Hasher) {
////        hasher.combine(id)
////    }
////}
//
////
////struct DrawerView: View {
////    @State private var showDrawer = false
////    @State private var selectedItem: String? = nil
////    @State private var isPresented = false
////    let drawerItems = [
////        DrawerItem(title: "First Item", destination: AnyView(SettingView())),
////        DrawerItem(title: "Second Item", destination: AnyView(ContentView())),
////        DrawerItem(title: "Third Item", destination: AnyView(HomeView())),
////    ]
////
////    var body: some View {
////        VStack {
////            Button(action: {
////                isPresented.toggle()
////            }) {
////                Text("Open Drawer")
////            }
////            .sheet(isPresented: $isPresented) {
////                List {
////                    ForEach(drawerItems, id: \.self) { item in
////                        Button(action: {
////                            switch item.title {
////                            case "First Item":
////                                selectedItem = "View1"
////                            case "Second Item":
////                                selectedItem = "View2"
////                            case "Third Item":
////                                selectedItem = "View3"
////                            default:
////                                break
////                            }
////                        }) {
////                            Text(item.title)
////                        }
////                    }
////                }
////                .onDisappear {
////                    if let selectedItem = selectedItem {
////                        switch selectedItem {
////                        case "View1":
////                            // Navigate to View1
////                            break
////                        case "View2":
////                            // Navigate to View2
////                            break
////                        case "View3":
////                            // Navigate to View3
////                            break
////                        default:
////                            break
////                        }
////                    }
////                }
////            }
////        }
////    }
////}
//
//import SwiftUI
//
//struct DrawerView: View {
//    @Binding var isOpen: Bool
//
//    let items = [
//        DrawerItem(name: "View 1", imageName: "doc", destination: AnyView(ContentView())),
//        DrawerItem(name: "View 2", imageName: "person.crop.circle", destination: AnyView(SettingView())),
//        DrawerItem(name: "View 3", imageName: "gear", destination: AnyView(HomeView()))
//    ]
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            ForEach(items, id: \.self) { item in
//                Button(action: {
//                    self.isOpen = false
//                    navigateTo(item.destination)
//                }) {
//                    HStack {
//                        Image(systemName: item.imageName)
//                            .font(.title)
//                            .foregroundColor(.gray)
//                            .frame(width: 24, height: 24)
//                        Text(item.name)
//                            .font(.headline)
//                            .foregroundColor(.gray)
//                    }
//                }
//                .padding()
//                .background(Color.white)
//                .cornerRadius(15)
//            }
//            Spacer()
//        }
//        .padding()
//        .frame(maxWidth: .infinity, alignment: .leading)
//        .background(Color.gray.opacity(0.2))
//    }
//
//    func navigateTo<Content: View>(_ destination: Content) {
//        UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: destination)
//        UIApplication.shared.windows.first?.makeKeyAndVisible()
//    }
//}
//
//struct DrawerItem: Identifiable, Equatable, Hashable {
//    let id = UUID()
//    let name: String
//    let imageName: String
//    let destination: AnyView
//
//    static func ==(lhs: DrawerItem, rhs: DrawerItem) -> Bool {
//        return lhs.id == rhs.id
//    }
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//}
