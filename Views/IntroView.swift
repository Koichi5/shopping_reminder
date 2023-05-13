//
//  IntroView.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/12.
//

import SwiftUI

struct IntroView: View {
    @State var isFullScreenPresented: Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                Text("Numbers を使い始める")
                    .font(.title)
                    .padding(.vertical, 40)
                IntroItemView(
                    systemName: "person.crop.circle",
                    title: "共同制作",
                    message: "Mac、iPad、iPhone、iCloud.comで他のユーザと同時に編集できます。"
                )
                IntroItemView(
                    systemName: "doc.text.image.fill",
                    title: "柔軟なキャンバス",
                    message: "複数の表、グラフ、およびイメージをキャンバスの好きな場所に配置できます。"
                )
                IntroItemView(
                    systemName: "function",
                    title: "強力な関数",
                    message: "数式の入力を始めるとすぐに内臓ヘルプや候補を表示します。"
                )
                IntroItemView(
                    systemName: "chart.bar.xaxis",
                    title: "インタラクティブグラフ",
                    message: "インタラクティブグラフでデータをわかりやすく表示します。"
                )
                Spacer()
                Button(action: {
                    isFullScreenPresented = true
                }) {
                    Text("続ける")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .background(Color.red.cornerRadius(10))
                        .padding(.horizontal, 32)
                }
//                NavigationLink {
//                    SideMenuContentView()
//                } label: {
//                    Text("続ける")
//                        .fontWeight(.bold)
//                        .font(.system(size: 20))
//                        .foregroundColor(Color.white)
//                        .frame(maxWidth: .infinity, minHeight: 48)
//                        .background(Color.red.cornerRadius(10))
//                        .padding(.horizontal, 32)
//                }
            }
            .fullScreenCover(isPresented: $isFullScreenPresented) {
                SideMenuContentView()
            }
            .task {
                do {
                    try await ShoppingItemRepository().addUserSnapshotListener()
                } catch {
                    print(error)
                }
            }
        }
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
    }
}
