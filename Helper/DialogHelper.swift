//
//  DialogHelper.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/10.
//

import SwiftUI

struct DialogHelper: View {
    @State private var isShowingAlert = false
//    let buttonText: String
    let systemName: String
    let titleText: String
    let messageText: String?
    let primaryButtonText: String
    let secondaryButtonText: String?
    let primaryButtonAction: (()-> Void)?
    let secondaryButtonAction: (() -> Void)?
    
    var body: some View {
        Button(action: { self.isShowingAlert = true}) {
            Image(systemName: systemName).foregroundColor(Color.foreground)
        }
        .alert(titleText, isPresented: $isShowingAlert) {
            Button(primaryButtonText) {
                primaryButtonAction?()
            }
//            secondaryButtonText != nil ?
            Button(action: {secondaryButtonAction?()}) {
                Text(secondaryButtonText ?? "")
            }
//            Button(secondaryButtonText!) {
//                secondaryButtonAction?()
//            } : nil
        } message: {
            Text(messageText ?? "")
        }
    }
}

struct DialogHelper_Previews: PreviewProvider {
    static var previews: some View {
        DialogHelper(systemName: "trash", titleText: "title", messageText: "message", primaryButtonText: "OK", secondaryButtonText: "NG", primaryButtonAction: {print("primary button pushed")}, secondaryButtonAction: nil)
    }
}
