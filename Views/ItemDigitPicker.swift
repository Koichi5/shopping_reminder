//
//  ItemDigitPicker.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/05/07.
//

import SwiftUI

struct ItemDigitPicker: View {
    @ObservedObject var userDefaultsHelper = UserDefaultsHelper()
    @Binding var selectedDigitsValue: String
    @Binding var selectedUnitsValue: String
    let digits = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30"]
    let units = ["時間ごと", "日ごと", "週間ごと", "ヶ月ごと"]
    
    var body: some View {
        HStack {
            VStack {
                Picker("", selection: $selectedDigitsValue) {
                    ForEach(digits, id: \.self) { item in
                        Text(item).tag(digits.indices)
                    }
                }.pickerStyle(.wheel)
            }
            VStack {
                Picker("", selection: $selectedUnitsValue) {
                    ForEach(units, id: \.self) { item in
                        Text(item).tag(units.indices)
                    }
                }.pickerStyle(.wheel)
            }
        }
    }
}

struct ItemDigitPicker_Previews: PreviewProvider {
    @State static var selectedDigitsValue = ""
    @State static var selectedUnitsValue = ""
    static var previews: some View {
        ItemDigitPicker(selectedDigitsValue: $selectedDigitsValue, selectedUnitsValue: $selectedUnitsValue)
    }
}
