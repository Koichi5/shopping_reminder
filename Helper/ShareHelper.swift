//
//  ShareHelper.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/06/23.
//

import Foundation
import UIKit

class ShareHelper: ObservableObject {
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
        _ = UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
}
