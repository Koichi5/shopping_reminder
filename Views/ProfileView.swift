//
//  ProfileView.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/05.
//

import SwiftUI

struct ProfileView: View {
    @State private var showingMenu = false
    var body: some View {
        ZStack {
            Color.red.edgesIgnoringSafeArea(
                .all)
            VStack(alignment: .leading) {
                Button(action: {self.showingMenu.toggle()}) {
                    Image(systemName: "line.horizontal.3")
                        .foregroundColor(.white)
                }
                .frame(width: 50.0, height: 50.0)
                Spacer()
                Text("This Is Profile")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                Spacer()
                HStack (){
                    Spacer()
                    Button(action: {
                        VibrationHelper().successVibration()
                    }) {
                        Text("success")
                    }
                    Spacer()
                    Button(action: {
                        VibrationHelper().errorVibration()
                    }) {
                        Text("error")
                    }
                    Spacer()
                    Button(action: {
                        VibrationHelper().warningVibration()
                    }) {
                        Text("warning")
                    }
                    Spacer()
                }
                HStack {
                    Spacer()
                    Button(action: {
                        VibrationHelper().lightVibration()
                    }) {
                        Text("light")
                    }
                    Spacer()
                    Button(action: {
                        VibrationHelper().mediumVibration()
                    }) {
                        Text("medium")
                    }
                    Spacer()
                    Button(action: {
                        VibrationHelper().heavyVibration()
                    }) {
                        Text("heavy")
                    }
                    Spacer()
                }
                HStack {
                    Spacer()
                    Button(action: {
                        VibrationHelper().feedbackVibration()
                    }) {
                        Text("feedback")
                    }
                    Spacer()
                    Button(action: {
                        VibrationHelper().longVibration()
                    }) {
                        Text("long")
                    }
                    Spacer()
                    Button(action: {
                        VibrationHelper().firstSoundVibration()
                    }) {
                        Text("firstSound")
                    }
                    Spacer()
                }
                HStack {
                    Spacer()
                    Button(action: {
                        VibrationHelper().secondSoundVibration()
                    }) {
                        Text("secondSound")
                    }
                    Spacer()
                    Button(action: {
                        VibrationHelper().thirdSoundVibration()
                    }) {
                        Text("thirdSound")
                    }
                    Spacer()
                    Button(action: {
                        VibrationHelper().fourthSoundVibration()
                    }) {
                        Text("fourthSound")
                    }
                    Spacer()
                }
                HStack {
                    Spacer()
                    Button(action: {
                        VibrationHelper().threeTimesVibration()
                    }) {
                        Text("threeTimes")
                    }
                    Spacer()
                    Button(action: {
                        VibrationHelper().noLimitVibration()
                    }) {
                        Text("noLimit")
                    }
                    Spacer()
                }
            }.padding(.horizontal) .frame(maxWidth: .infinity)
        }
        .offset(x: showingMenu ? 200.0 : 0.0, y: 0)
        .animation(.easeOut)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
