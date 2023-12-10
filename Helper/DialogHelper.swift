//
//  DialogHelper.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/10.
//

import SwiftUI

struct DialogHelper: View {
    @ObservedObject var userDefaultsHelper = UserDefaultsHelper()
    @State private var isShowingAlert = false
    let systemName: String?
    let buttonText: String?
    let titleText: String
    let messageText: String?
    let primaryButtonText: String
    let secondaryButtonText: String?
    let primaryButtonAction: (()-> Void)?
    let secondaryButtonAction: (() -> Void)?
    
    var body: some View {
        Button(action: { self.isShowingAlert = true}) {
            Image(systemName: systemName ?? "")
                .foregroundColor(Color.foreground)
            Text(buttonText ?? "")
                .foregroundColor(Color.foreground)
        }
        .alert(isPresented: $isShowingAlert) {
            Alert(title: Text(titleText), message: Text(messageText ?? ""), primaryButton: .default(Text(primaryButtonText)) {
                primaryButtonAction?()
            }, secondaryButton: .cancel(Text(secondaryButtonText ?? "")) {secondaryButtonAction?()})
        }
        //        .alert(titleText, isPresented: $isShowingAlert) {
        //            Button(primaryButtonText) {
        //                primaryButtonAction?()
        //            }
        //            Button(action: {secondaryButtonAction?()}) {
        //                Text(secondaryButtonText ?? "")
        //            }
        //        } message: {
        //            Text(messageText ?? "")
        //        }
        //        .preferredColorScheme(userDefaultsHelper.isDarkModeOn ? .dark : .light)
    }
}

//struct DialogHelper_Previews: PreviewProvider {
//    static var previews: some View {
//        DialogHelper(systemName: "trash", buttonText: "", titleText: "title", messageText: "message", primaryButtonText: "OK", secondaryButtonText: "NG", primaryButtonAction: {print("primary button pushed")}, secondaryButtonAction: nil)
//    }
//}
