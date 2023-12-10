////
////  MapView.swift
////  shopping_reminder
////
////  Created by Koichi Kishimoto on 2023/08/08.
////
//
//import SwiftUI
//import CoreLocation
//import MapKit
//
//struct MapView: View {
//
////    var pointList = [
////        Point(latitude: 35.709152712026265, longitude: 139.80771829999996),
////        Point(latitude: 35.711554715026265, longitude: 139.81371829999996),
////        Point(latitude: 35.712527719026265, longitude: 139.81071829999996)
////    ]
//
//    @State  var region = MKCoordinateRegion(center: CLLocationCoordinate2D(
//            latitude: 35.710057714926265,
//            longitude: 139.81071829999996
//        ),
//        latitudinalMeters: 1000.0,
//        longitudinalMeters: 1000.0
//    )
//    var body: some View {
//        Map(coordinateRegion: $region,
//            interactionModes: .all,
//            showsUserLocation: true,
//            userTrackingMode: .constant(MapUserTrackingMode.follow)
////            annotationItems: pointList,
////            annotationContent: { point in MapMarker(coordinate: point.coordinate, tint: .orange)}
//        )
//            .edgesIgnoringSafeArea(.bottom)
//            .ignoresSafeArea()
//    }
//
//}
//
//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView()
//    }
//}


import SwiftUI
import MapKit

struct MapView: View {
    //    @State var locationName: String = "テスト"
    @Binding var pinCoordinate: CLLocationCoordinate2D
    @State var pinDropped: Bool = false
    @State var selectedTab: Int = 1
    
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                TabView(selection: $selectedTab) {
                    MapViewWithPinMode(pinCoordinate: $pinCoordinate, pinDropped: $pinDropped)
                        .tabItem {
                            Image(systemName: "mappin.circle")
                            Text("ピンドラッグモード版")
                        }.tag(1)
                    MapViewWithCross(pinCoordinate: $pinCoordinate, pinDropped: $pinDropped)
                        .tabItem {
                            Image(systemName: "plus.viewfinder")
                            Text("十字版")
                        }.tag(2)
                }
                .padding()
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        BackButtonView()
                    }
                }
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
