//
//  IntroView.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/12.
//

import SwiftUI
import ConcentricOnboarding

struct IntroView: View {
    @ObservedObject var userDefaultsHelper = UserDefaultsHelper()
    @State var isFullScreenPresented: Bool = false
    @State var didGoToLastPage: Bool = false
    @State private var currentIntroPageIndex: Int = 1
    @State private var didIntroductionEnded: Bool = false
    let pageContents = IntroPageData.pages.map {(IntroPageView(page: $0), $0.color)}
    
    var body: some View {
        ConcentricOnboardingView(pageContents: pageContents)
            .duration(1.0)
            .nextIcon(
                self.didGoToLastPage
                ? "xmark"
                :  "chevron.forward")
            .animationDidEnd {
                print("Animation Did End")
            }
            .didGoToLastPage {
                didGoToLastPage = true
            }
            .didChangeCurrentPage { _ in
                currentIntroPageIndex += 1
                if (IntroPageData.pages.count < currentIntroPageIndex) {
                    didIntroductionEnded = true
                }
            }
            .fullScreenCover(isPresented: $didIntroductionEnded) {
                HomeView()
            }
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
    }
}
