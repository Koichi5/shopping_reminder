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
    let fileName: String
    
    func makeUIView(context: Context) -> UIView {
        let view = LottieAnimationView(name: fileName)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let parentView = UIView()
        parentView.addSubview(view)
        parentView.addConstraints([
            view.widthAnchor.constraint(equalTo: parentView.widthAnchor),
            view.heightAnchor.constraint(equalTo: parentView.heightAnchor)
        ])
        return parentView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        guard let view = uiView.subviews.compactMap({ $0 as? LottieAnimationView }).first else { return }
        view.loopMode = .loop
        view.play()
    }
}

struct LottieView_Previews: PreviewProvider {
    static var previews: some View {
        LottieView(fileName: "shopping_item_view_lottie.json")
    }
}
