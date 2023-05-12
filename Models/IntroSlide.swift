//
//  IntroSlide.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/12.
//

import Foundation

struct IntroSlide: Identifiable {
    let id = UUID()
    let imagePath: String
    let title: String
    let description: String
    let onNextButton: () -> Void
}

extension IntroSlide {
    static let introSlides: [IntroSlide] = [
        IntroSlide(
            imagePath: "",
            title: "first",
            description: "",
            onNextButton: {}
        ),
        IntroSlide(
            imagePath: "",
            title: "second",
            description: "",
            onNextButton: {}
        ),
        IntroSlide(
            imagePath: "",
            title: "third",
            description: "",
            onNextButton: {}
        )
    ]
}
