//
//  ShareHelper.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/06/23.
//

import Foundation
import UIKit

class ShareHelper: ObservableObject {
//    func shareApp(
//        shareText: String,
//        shareImage: UIImage?,
//        shareLink: String
//    ) {
//        let items = [shareText, URL(string: shareLink)!] as [Any]
//        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
//        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
//        let rootVC = windowScene?.windows.first?.rootViewController
//        rootVC?.present(activityVC, animated: true)
//    }
    func shareApp(
        shareText: String,
        shareImage: UIImage?,
        shareLink: String
    ) {
        let items = [shareText, URL(string: shareLink)!] as [Any]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            if let rootVC = window.rootViewController {
                rootVC.present(activityVC, animated: true, completion: nil)
            }
        }
    }


    func shareText(shareText: String) {
        let items = [shareText] as [Any]
        let activityVS = UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
}
