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
    @FocusState private var focusedField: Field?
    @State private var itemName = ""
    @State private var showingMenu = false
    @State private var isShowSheet: Bool = false
    //    @FocusState var focused: Bool
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.edgesIgnoringSafeArea(
                    .all)
                VStack(alignment: .leading) {
                    //                    Button(action: {self.showingMenu.toggle()}) {
                    //                        Image(systemName: "line.horizontal.3")
                    //                            .foregroundColor(Color.foreground)
                    //                    }
                    //                    .frame(width: 50.0, height: 50.0)
                    Spacer()
                    Text("This Is Home")
                        .font(
                            .largeTitle)
                        .foregroundColor(
                            .foreground)
                        .frame(maxWidth: .infinity)
                    Spacer()
                }.padding(.horizontal) .frame(maxWidth: .infinity)
            }
            .navigationBarTitle("Home")
            .navigationBarTitleDisplayMode(showingMenu ? .inline : .automatic)
            .toolbar {
                ToolbarItem (placement: .cancellationAction) {
                    Button (action: {self.showingMenu.toggle()}) {
                        Image(systemName: showingMenu ? "xmark" : "line.horizontal.3")
                            .foregroundColor(Color.foreground)
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {}) {
                        Image(systemName: "trash").foregroundColor(Color.foreground)
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        isShowSheet.toggle()
                        //                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                        //                            focusedField = .itemName
                        //                        }
                        //                        focusState = .itemName
                    }) {
                        Image(systemName: "plus").foregroundColor(Color.foreground)
                    }
                    //                    .toolbar {
                    //                        ToolbarItem(placement: .keyboard) {
                    //                            Text("Hello")
                    //                        }
                    //                    }
                }
            }
        }.sheet(isPresented: $isShowSheet) {
            AddItemView(isShowSheet: $isShowSheet)
            //            VStack {
            //                HStack {
            //                    Spacer()
            //                    Button(action: {
            //                        focusedField = nil
            //                        isBottomSheetPresented = false
            //                    }) {
            //                        Text("close")
            //                    }
            //                }
            //                TextField("ItemName", text: $itemName)
            //                    .focused($focusedField, equals: .itemName)
            //                    .textFieldStyle(RoundedBorderTextFieldStyle())
            //                    .ignoresSafeArea(.keyboard, edges: .bottom)
            //                    .padding()
            //            }
        }
        //        .onAppear() {
        //            // 画面を表示してから0.5秒後にキーボードを表示
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
        //                focusedField = .itemName
        //            }
        //        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .offset(x: showingMenu ? 200.0 : 0.0, y: 0)
        .animation(.easeOut)
    }
}

//struct AddItemView: View {
//    enum Field: Hashable {
//        case text
//    }
//    // @FocusState変数は、現在フォーカス中か、フォーカスしてないのか（Bool型）の定義ではなく、
//    // 現在フォーカスしているのが、どのテキストフィールドか（カスタムField型）を定義します。
//    @FocusState private var focusedField: Field?
//    // ContentView ⇄ SecondViewのシートを管理する状態変数
//    @Binding var isShowSheet: Bool
//
//    @State private var inputText = ""
//
//    var body: some View {
//        VStack {
//            TextField("タイトル", text: $inputText)
//                .padding()
//                .border(.blue)
//                .padding()
//                .focused($focusedField, equals: .text)
//        }
//        .onAppear() {
//            // 画面を表示してから0.5秒後にキーボードを表示
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
//                focusedField = .text
//            }
//        }
//    }
//}

//import SwiftUI
//
//struct HomeView: View {
//    @State var isOpenSideMenu: Bool = false
//    @State var text = "Hello, World!"
//    var body: some View {
//        ZStack {
//            NavigationStack {
//                VStack {
//                    Text("Hello, World!")
//                }
//                .navigationBarTitle(Text("home"))
//    .toolbar {
//        ToolbarItem(placement: .cancellationAction) {
//            Button(action: {
//                self.isOpenSideMenu.toggle()
//            }) {
//                Image(systemName: "line.horizontal.3").foregroundColor(.black)
//            }
//            Button(action: {}) {
//                Image(systemName: "gearshape.fill").foregroundColor(.black)
//            }
//        }
//    }
//                    VStack {
//                        Button(action: {}) {
//                            Image(systemName: "gearshape.fill").foregroundColor(.black)
//                        }
//                    }
//                }
//            }
//            SideMenuView(isOpen: $isOpenSideMenu, text: $text)
//                .edgesIgnoringSafeArea(.all)
//        }
//    }
//}

//struct HomeView: View {
//    @State private var showingMenu = false
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                Color.background.edgesIgnoringSafeArea(
//                    .all)
//                .navigationBarTitle("Home").navigationBarTitleDisplayMode(showingMenu ? .inline : .automatic)
//                .toolbar {
//                    ToolbarItem(placement: .cancellationAction) {
//                        Button(action: {self.showingMenu.toggle()}) {
//                            Image(systemName: "line.horizontal.3").foregroundColor(Color.foreground)
//                        }
//                        Button(action: {}) {
//                            Image(systemName: "gearshape.fill").foregroundColor(Color.foreground)
//                        }
//                    }
//                }
//                .navigationBarTitle("Home")
//                .foregroundColor(.red)
//                VStack(alignment: .leading) {
//                    Button(action: {self.showingMenu.toggle()}) {
//                        Image(systemName: "line.horizontal.3")
//                            .foregroundColor(Color.foreground)
//                    }
//                    .frame(width: 50.0, height: 50.0)
//                    Text("This Is Home")
//                        .font(
//                            .largeTitle)
//                        .foregroundColor(Color.foreground)
//                        .frame(maxWidth: .infinity)
//                }
//                .padding(.horizontal) .frame(maxWidth: .infinity)
//            }
//            .offset(x: showingMenu ? 200.0 : 0.0, y: 0)
//            .animation(.easeOut)
//        }
//        .navigationBarTitle("Home")
//        .toolbar {
//            ToolbarItem(placement: .cancellationAction) {
//                Button(action: {
//                }) {
//                    Image(systemName: "line.horizontal.3").foregroundColor(.black)
//                }
//                Button(action: {}) {
//                    Image(systemName: "gearshape.fill").foregroundColor(.black)
//                }
//                Button(action: {self.showingMenu.toggle()}) {
//                    Image(systemName: "line.horizontal.3")
//                        .foregroundColor(Color.foreground)
//                }
//                .frame(width: 50.0, height: 50.0)
//            }
//        }
//    }
//}

//struct ProfileView: View {
//    @State private var showingMenu = false
//    var body: some View {
//        ZStack {
//            Color.red.edgesIgnoringSafeArea(
//                .all)
//            VStack(alignment: .leading) {
//                Button(action: {self.showingMenu.toggle()}) {
//                    Image(systemName: "line.horizontal.3")
//                        .foregroundColor(.white)
//                }
//                .frame(width: 50.0, height: 50.0)
//                Spacer()
//                Text("This Is Profile")
//                    .font(
//                        .largeTitle)
//                    .foregroundColor(
//                        .white)
//                    .frame(maxWidth: .infinity)
//                Spacer()
//            }.padding(.horizontal) .frame(maxWidth: .infinity)
//        }
//        .offset(x: showingMenu ? 200.0 : 0.0, y: 0)
//        .animation(.easeOut)
//    }
//}
//struct ChatView: View {
//    @State private var showingMenu = false
//    var body: some View {
//        ZStack {
//
//            Color.blue.edgesIgnoringSafeArea(
//                .all)
//            VStack(alignment: .leading) {
//                Button(action: {self.showingMenu.toggle()}) {
//                    Image(systemName: "line.horizontal.3")
//                        .foregroundColor(.white)
//                }
//                .frame(width: 50.0, height: 50.0)
//                Spacer()
//                Text("This Is Chat")
//                    .font(
//                        .largeTitle)
//                    .foregroundColor(
//                        .white)
//                    .frame(maxWidth: .infinity)
//                Spacer()
//            }.padding(.horizontal) .frame(maxWidth: .infinity)
//        }
//        .offset(x: showingMenu ? 200.0 : 0.0, y: 0)
//        .animation(.easeOut)
//    }
//}
//struct LogoutView: View {
//    @State private var showingMenu = false
//        var body: some View {
//            ZStack {
//
//                Color.green.edgesIgnoringSafeArea(
//                    .all)
//                VStack(alignment: .leading) {
//                    Button(action: {self.showingMenu.toggle()}) {
//                        Image(systemName: "line.horizontal.3")
//                            .foregroundColor(.white)
//                    }
//                    .frame(width: 50.0, height: 50.0)
//                    Spacer()
//                    Text("This Is Logout")
//                        .font(
//                            .largeTitle)
//                        .foregroundColor(
//                            .white)
//                        .frame(maxWidth: .infinity)
//                    Spacer()
//                }.padding(.horizontal) .frame(maxWidth: .infinity)
//            }
//            .offset(x: showingMenu ? 200.0 : 0.0, y: 0)
//            .animation(.easeOut)
//        }
//}

//struct ProfileView: View {
//    @State private var showingMenu = false
//    var body: some View {
//        ZStack {
//            Color.red.edgesIgnoringSafeArea(
//                .all)
//            VStack(alignment: .leading) {
//                Button(action: {self.showingMenu.toggle()}) {
//                    Image(systemName: "line.horizontal.3")
//                        .foregroundColor(.white)
//                }
//                .frame(width: 50.0, height: 50.0)
//                Spacer()
//                Text("This Is Profile")
//                    .font(
//                        .largeTitle)
//                    .foregroundColor(
//                        .white)
//                    .frame(maxWidth: .infinity)
//                Spacer()
//            }.padding(.horizontal) .frame(maxWidth: .infinity)
//        }
//        .offset(x: showingMenu ? 200.0 : 0.0, y: 0)
//        .animation(.easeOut)
//    }
//}
//struct ChatView: View {
//    @State private var showingMenu = false
//    var body: some View {
//        ZStack {
//
//            Color.blue.edgesIgnoringSafeArea(
//                .all)
//            VStack(alignment: .leading) {
//                Button(action: {self.showingMenu.toggle()}) {
//                    Image(systemName: "line.horizontal.3")
//                        .foregroundColor(.white)
//                }
//                .frame(width: 50.0, height: 50.0)
//                Spacer()
//                Text("This Is Chat")
//                    .font(
//                        .largeTitle)
//                    .foregroundColor(
//                        .white)
//                    .frame(maxWidth: .infinity)
//                Spacer()
//            }.padding(.horizontal) .frame(maxWidth: .infinity)
//        }
//        .offset(x: showingMenu ? 200.0 : 0.0, y: 0)
//        .animation(.easeOut)
//    }
//}
//struct LogoutView: View {
//    @State private var showingMenu = false
//        var body: some View {
//            ZStack {
//
//                Color.green.edgesIgnoringSafeArea(
//                    .all)
//                VStack(alignment: .leading) {
//                    Button(action: {self.showingMenu.toggle()}) {
//                        Image(systemName: "line.horizontal.3")
//                            .foregroundColor(.white)
//                    }
//                    .frame(width: 50.0, height: 50.0)
//                    Spacer()
//                    Text("This Is Logout")
//                        .font(
//                            .largeTitle)
//                        .foregroundColor(
//                            .white)
//                        .frame(maxWidth: .infinity)
//                    Spacer()
//                }.padding(.horizontal) .frame(maxWidth: .infinity)
//            }
//            .offset(x: showingMenu ? 200.0 : 0.0, y: 0)
//            .animation(.easeOut)
//        }
//}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
