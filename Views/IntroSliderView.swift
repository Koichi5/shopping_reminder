//
//  IntroSliderView.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/12.
//
//
//import SwiftUI
//import Algorithms
//
//struct IntroSliderView: View {
//    @State var pageIndex = 0
//    var body: some View {
//        TabView (selection: $pageIndex) {
//            ForEach(IntroSlide.introSlides.indexed(), id: \.index) { index, slide in
//                IntroSlideView(slide: slide).tag(index)
//            }
//        }
//        .tabViewStyle(PageTabViewStyle())
//        .indexViewStyle(
//            PageIndexViewStyle(
//            backgroundDisplayMode: (pageIndex + 1 == (IntroSlide.introSlides.count)) ? .never : .always
//            )
//        )
//    }
//}
//
//struct IntroSliderView_Previews: PreviewProvider {
//    static var previews: some View {
//        IntroSliderView()
//    }
//}
