//
//  BackButtonHelper.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/06/28.
//

import SwiftUI

struct BackButtonHelper: View {
    @Environment(\.presentationMode) var presentationMode
       var body: some View {
           Button(action: {
               presentationMode.wrappedValue.dismiss()
           }, label: {
               Image(systemName: "chevron.backward")
                   .foregroundColor(Color.foreground)
           })
       }
}

struct BackButtonHelper_Previews: PreviewProvider {
    static var previews: some View {
        BackButtonHelper()
    }
}
