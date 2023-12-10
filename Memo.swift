//
//  Memo.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/04.
//

import Foundation
import SwiftUI

//struct BottomSheet<Content: View>: View {
//    @Binding var isPresented: Bool
//    let content: Content
//
//    init(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) {
//        _isPresented = isPresented
//        self.content = content()
//    }
//
//    var body: some View {
//        VStack {
//            content
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color.white)
//        .cornerRadius(20)
//        .shadow(radius: 10)
//        .padding()
//        .offset(y: isPresented ? 0 : UIScreen.main.bounds.height)
//        .animation(.spring())
//    }
//}
//
//
//struct MemoView: View {
//    @State private var isShowingSheet = false
//    @State private var text = ""
//
//    var body: some View {
//        VStack {
//            // 画面上部に配置するコンテンツ
//            // ...
//
//            // ボタンを配置
//            Button(action: {
//                self.isShowingSheet.toggle()
//            }) {
//                Text("Show Bottom Sheet")
//                    .foregroundColor(.white)
//                    .padding()
//                    .background(Color.blue)
//                    .cornerRadius(10)
//            }
//            // bottom sheet を表示
//            BottomSheet(isPresented: $isShowingSheet) {
//                VStack {
//                    Text("Enter text below")
//                        .font(.headline)
//                        .padding()
//
//                    // テキストフィールドを配置
//                    TextField("Enter text", text: self.$text)
//                        .padding()
//                        .background(Color.gray.opacity(0.1))
//                        .cornerRadius(10)
//
//                    // bottom sheet を閉じるためのボタン
//                    Button(action: {
//                        self.isShowingSheet = false
//                    }) {
//                        Text("Close")
//                            .foregroundColor(.white)
//                            .padding()
//                            .background(Color.blue)
//                            .cornerRadius(10)
//                    }
//                }
//            }
//        }
//    }
//}

//struct MemoView: View {
//    @State private var showingKeyboard = false
//    @State private var text = ""
//
//    var body: some View {
//        VStack {
//            TextField("Enter text", text: $text)
//            Button("Open Keyboard") {
//                showingKeyboard = true
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                    UIApplication.shared.sendAction(#selector(UIResponder.becomeFirstResponder), to: nil, from: nil, for: nil)
//                }
//            }
//        }
//        .padding()
//        .background(Color.gray.opacity(0.2))
//        .sheet(isPresented: $showingKeyboard, onDismiss: {
//            DispatchQueue.main.async {
//                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//            }
//        }, content: {
//            EmptyView()
//        })
//    }
//}

import SwiftUI

struct MemoView: View {
    // ContentView ⇄ SecondViewのシートを管理する状態変数
    @State var isShowSheet: Bool = false

    var body: some View {
        VStack{
            Button{
                isShowSheet.toggle()
            }label: {
                Text("Go SecondView")
            }
        }
        .sheet(isPresented: $isShowSheet) {
            if #available(iOS 15.0, *) {
                SecondView(isShowSheet: $isShowSheet)
            } else {
                // Fallback on earlier versions
            }
        }
    }
}

@available(iOS 15.0, *)
struct SecondView: View {
    // フォーカスが当たるTextFieldを、判断するためのenumを作成します。
    enum Field: Hashable {
        case text
    }
    // @FocusState変数は、現在フォーカス中か、フォーカスしてないのか（Bool型）の定義ではなく、
    // 現在フォーカスしているのが、どのテキストフィールドか（カスタムField型）を定義します。
    @FocusState private var focusedField: Field?
    // ContentView ⇄ SecondViewのシートを管理する状態変数
    @Binding var isShowSheet: Bool

    @State private var inputText = ""

    var body: some View {
        VStack {
            TextField("タイトル", text: $inputText)
                .padding()
                .border(.blue)
                .padding()
                .focused($focusedField, equals: .text)
        }
        .onAppear() {
            // 画面を表示してから0.5秒後にキーボードを表示
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                focusedField = .text
            }
        }
    }
}



struct MemoView_Previews: PreviewProvider {
    static var previews: some View {
        MemoView()
    }
}




//struct ShoppingItem: Identifiable, Codable {
//    let id: UUID
//    let name: String
//    let price: Int
//    let quantity: Int
//    let expirationDate: Date
//
//    init(id: UUID = UUID(), name: String, price: Int, quantity: Int, expirationDate: Date) {
//        self.id = id
//        self.name = name
//        self.price = price
//        self.quantity = quantity
//        self.expirationDate = expirationDate
//    }
//
//    // 通知を送信する関数
//    func sendNotification() {
//        let title = "商品の有効期限が近づいています"
//        let body = "\(name)の有効期限が迫っています。早めに使用してください。"
//        let identifier = id.uuidString
//
//        let notificationCenter = UNUserNotificationCenter.current()
//        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
//            if let error = error {
//                print("Error requesting notification authorization: \(error.localizedDescription)")
//                return
//            }
//            if granted {
//                let content = UNMutableNotificationContent()
//                content.title = title
//                content.body = body
//                content.sound = UNNotificationSound.default
//
//                let calendar = Calendar(identifier: .gregorian)
//                let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: expirationDate)
//                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
//
//                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//                notificationCenter.add(request) { error in
//                    if let error = error {
//                        print("Error sending notification: \(error.localizedDescription)")
//                    } else {
//                        print("Notification sent successfully")
//                    }
//                }
//            } else {
//                print("Notification authorization not granted")
//            }
//        }
//    }
//}

//import Foundation
//
//struct ShoppingItem: Identifiable, Codable {
//    let id: UUID
//    var name: String
//    var category: String
//    var addedAt: Date
//    var expirationDays: Int
//    var customURL: String?
//
//    init(name: String, category: String, addedAt: Date, expirationDays: Int, customURL: String? = nil, id: UUID = UUID()) {
//        self.name = name
//        self.category = category
//        self.addedAt = addedAt
//        self.expirationDays = expirationDays
//        self.customURL = customURL
//        self.id = id
//    }
//}

//
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

//Firestore.firestore().collection("users").document(currentUser!.uid).collection("items").addSnapshotListener { (querySnapshot, error) in
//    // ドキュメントスナップショットの取得に失敗した場合はエラー内容を表示
//    guard let documents = querySnapshot?.documents else {
//        print("No documents")
//        return
//    }
//
//    result = documents.map { (queryDocumentSnapshot) -> ShoppingItem in
//        let data = queryDocumentSnapshot.data()
//        let name = data["name"] as? String ?? ""
//        let category = data["category"] as? Category ?? Category(name: "", color: CategoryColor.black)
//        let addea_at = (data["added_at"] as? Timestamp)?.dateValue() ?? Date()
//        let custom_url = data["custom_url"] as? String ?? ""
//        let expiration_date = (data["expiration_date"] as? Timestamp)?.dateValue() ?? Date()
//        result.append(ShoppingItem(
//            name: name,
//            category: category,
//            addedAt: addea_at,
//            expirationDate: expiration_date,
//            customURL: custom_url
//        ))
//        return ShoppingItem(
//            name: name,
//            category: category,
//            addedAt: addea_at,
//            expirationDate: expiration_date,
//            customURL: custom_url
//        )
//    }

//func addShoppingItemWithDocumentId(shoppingItem: ShoppingItem) async throws -> String {
//    var newDocReference = ""
//    var docId = ""
//    let currentUser = AuthModel().getCurrentUser()
//    if currentUser == nil {
//        print("current user is nil")
//    } else {
//        let userRef = Firestore.firestore().collection("users").document(currentUser!.uid)
//        let itemsRef = userRef.collection("items")
//        docId = itemsRef.document().documentID
//        do {
//            try itemsRef.document(docId).setData(from: shoppingItem)
//            try await itemsRef.document(docId).updateData([
//                "id": docId
//            ])
//            print("newDocReference:  \(docId)")
//        }
//        catch {
//            print(error)
//        }
//    }
//    print("newDocReference in addnshopping item with document id func: \(docId)")
//    return docId
//}
