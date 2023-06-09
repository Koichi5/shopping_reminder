//
//  ChatView.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/05.
//
//
//import SwiftUI
//
//struct ChatView: View {
//    @State private var showingMenu = false
//    var body: some View {
//        ZStack {
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
//
//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView()
//    }
//}
