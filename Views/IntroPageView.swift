//
//  IntroPageView.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/06/21.
//


import SwiftUI

struct IntroPageView: View {
    
    @ObservedObject var userDefaultsHelper = UserDefaultsHelper()
    let page: PageData
    let imageWidth: CGFloat = 250
    let imageHeight: CGFloat = 250
    let textWidth: CGFloat = 350
    
    var body: some View {
        return VStack(alignment: .center, spacing: 50) {
            Text(page.title)
                .font(.system(size: 25, weight: .bold, design: .rounded))
                .foregroundColor(page.textColor)
                .frame(width: textWidth)
                .multilineTextAlignment(.center)
            LottieView(fileName: page.imageName)
                .id(page.imageName)
                .frame(width: imageWidth, height: imageHeight)
                Text(page.content)
                    .font(Font.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(page.textColor)
                    .frame(width: 300, alignment: .center)
                    .multilineTextAlignment(.center)
        }
    }
}
