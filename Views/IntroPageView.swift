//
//  IntroPageView.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/06/21.
//

import SwiftUI

import SwiftUI

struct IntroPageView: View {
    
    @ObservedObject var userDefaultsHelper = UserDefaultsHelper()
    let page: PageData
    let imageWidth: CGFloat = 250
    let imageHeight: CGFloat = 250
    let textWidth: CGFloat = 350
    
    var body: some View {
        let size = UIImage(named: page.imageName)?.size ?? .zero
        let aspect = size.width / size.height
        
        return VStack(alignment: .center, spacing: 50) {
            Text(page.title)
                .font(.system(size: 35, weight: .bold, design: .rounded))
                .foregroundColor(page.textColor)
                .frame(width: textWidth)
                .multilineTextAlignment(.center)
            LottieView(fileName: page.imageName)
                .frame(width: imageWidth, height: imageHeight)
//            Image(page.imageName)
//                .resizable()
//                .aspectRatio(aspect, contentMode: .fill)
//                .frame(width: imageWidth, height: imageWidth)
//                .cornerRadius(40)
//                .clipped()
            VStack(alignment: .center, spacing: 5) {
//                Text(page.header)
//                    .font(.system(size: 25, weight: .bold, design: .rounded))
//                    .foregroundColor(page.textColor)
//                    .frame(width: 300, alignment: .center)
//                    .multilineTextAlignment(.center)
                Text(page.content)
                    .font(Font.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(page.textColor)
                    .frame(width: 300, alignment: .center)
                    .multilineTextAlignment(.center)
            }
        }
//        .preferredColorScheme(userDefaultsHelper.isDarkModeOn ? .dark : .light)
    }
}

//struct IntroPageView_Previews: PreviewProvider {
//    static var previews: some View {
//        IntroPageView()
//    }
//}
