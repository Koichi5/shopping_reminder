//
//  ContentView.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/02.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Local Notification Demo").padding()
            Button(action:{
            }) {
                Text("Send Notification after 5 seconds !")
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
