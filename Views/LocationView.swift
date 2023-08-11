////
////  LocationView.swift
////  shopping_reminder
////
////  Created by Koichi Kishimoto on 2023/08/07.
////
//
//import SwiftUI
//
//struct LocationView: View {
//    @StateObject var locationViewModel = LocationViewModel()
//    var body: some View {
//        switch locationViewModel.authorizationStatus {
//        case .notDetermined:
//            RequestLocationView()
//                .environmentObject(locationViewModel)
//        case .restricted:
//            ErrorView(errorText: "位置情報の使用が制限されています。")
//        case .denied:
//            ErrorView(errorText: "位置情報を使用できません。")
//        case .authorizedAlways, .authorizedWhenInUse:
//            TrackingView()
//                .environmentObject(locationViewModel)
//        default:
//            Text("Unexpected Status")
//        }
//    }
//}
//
//struct LocationView_Previews: PreviewProvider {
//    static var previews: some View {
//        LocationView()
//    }
//}
