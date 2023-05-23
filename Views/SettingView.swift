//
//  SettingView.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/05.
//

import SwiftUI

struct SettingView: View {
    @State private var showingMenu = false
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.edgesIgnoringSafeArea(.all)
                List {
                    HStack {
                        DialogHelper(
                            systemName: nil,
                            buttonText: "ログアウト",
                            titleText: "ログアウトしますか？",
                            messageText: "",
                            primaryButtonText: "いいえ",
                            secondaryButtonText: "ログアウト",
                            primaryButtonAction: nil,
                            secondaryButtonAction: {
                                AuthViewModel().signOut()
                            }
                        )
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    Text("バイブレーション")
                    Text("ダークモード")
                }
            }
            .navigationBarTitle("Settings")
            .navigationBarTitleDisplayMode(showingMenu ? .inline : .automatic)
            .toolbar {
                ToolbarItem (placement: .cancellationAction) {
                    Button (action: {self.showingMenu.toggle()}) {
                        Image(systemName: showingMenu ? "xmark" : "line.horizontal.3")
                            .foregroundColor(Color.foreground)
                    }
                }
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .offset(x: showingMenu ? 200.0 : 0.0, y: 0)
        .animation(.easeOut)
    }
}
    
    struct SettingView_Previews: PreviewProvider {
        static var previews: some View {
            SettingView()
        }
    }
