//
//  LottieView.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/12.
//

import SwiftUI
import Lottie
import UIKit

struct LottieView: UIViewRepresentable {
    private let lottieView = LottieAnimationView()
    private let baseView = UIView()
    
    init(fileName: String) {
        lottieView.animation = LottieAnimation.named(fileName)
        lottieView.contentMode = .scaleAspectFit
        lottieView.loopMode = .loop
        baseView.addSubview(lottieView)
        lottieView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            baseView.topAnchor.constraint(equalTo: lottieView.topAnchor),
            baseView.leadingAnchor.constraint(equalTo: lottieView.leadingAnchor),
            baseView.trailingAnchor.constraint(equalTo: lottieView.trailingAnchor),
            baseView.bottomAnchor.constraint(equalTo: lottieView.bottomAnchor)
        ])
        lottieView.updateConstraints()
    }
    
    func makeUIView(context: Context) -> UIView {
        baseView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

//struct LottieView_Previews: PreviewProvider {
//    static var previews: some View {
//        LottieView()
//    }
//}
