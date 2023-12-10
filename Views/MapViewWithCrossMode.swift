//
//  MapViewWithCross.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/08/08.
//

import SwiftUI
import MapKit

struct PinLocationInfo: Identifiable {
    let id: UUID
    let location: CLLocationCoordinate2D
//    let name: String
    
    init(id: UUID = UUID(), location: CLLocationCoordinate2D) {
        self.id = id
        self.location = location
//        self.name = name
    }
}


struct MapWithCross: View {
    @ObservedObject var locationManager: LocationManager
    
    @Binding var pinCoordinate: CLLocationCoordinate2D
    @Binding var pinDropped: Bool
    @State var region: MKCoordinateRegion = MKCoordinateRegion()
//    var pinName: String
    
    var body: some View {
        ZStack (alignment: .topTrailing) {
            let items: [PinLocationInfo] = pinDropped ? [PinLocationInfo(location: pinCoordinate)] : []
            Map(coordinateRegion: $region,
                interactionModes: .all,
                showsUserLocation: true,
                userTrackingMode: nil,
                annotationItems: items,
                annotationContent: { place in
                MapAnnotation(coordinate: place.location, anchorPoint: CGPoint(x: 0.0, y: 0.5)) {
                    HStack {
                        Image(systemName: "mappin.circle.fill")
                            .scaleEffect(1.5)
//                        Text(place.name)
//                            .padding(.leading, -8)
                    }
                    .foregroundColor(Color(hex: "7CC7E8"))
                    .offset(x: -12)
                }
            })
//            ZStack(alignment: .topTrailing) {
                Button(action: {
                    locationManager.startUpdatingLocation()
                }) {
                    Image(systemName: "location.circle.fill")
                        .foregroundColor(Color.blue)
                        .scaleEffect(1.5)
                }
                .padding()
//            }
            ZStack(alignment: .center) {
                Rectangle()
                    .stroke(lineWidth: 0.5)
                    .foregroundColor(Color.gray)
                    .frame(width: 1)
                Rectangle()
                    .stroke(lineWidth: 0.5)
                    .foregroundColor(Color.gray)
                    .frame(height: 1)
            }
        }
        .sync($locationManager.region, with: $region)
    }
}

struct MapViewWithCross: View {
    @StateObject var locationManager = LocationManager()
    
    @Binding var pinCoordinate: CLLocationCoordinate2D
    @Binding var pinDropped: Bool
//    @Environment(\.dismiss) var dismiss

//    var pinName: String
    
    var body: some View {
        VStack {
            MapWithCross(locationManager: locationManager, pinCoordinate: $pinCoordinate, pinDropped: $pinDropped)
            HStack {
                Button(action: {
                    pinCoordinate = locationManager.region.center
                    pinDropped = true
                }){
                    HStack {
                        Image(systemName: "mappin.circle.fill")
                        Text("ピンを設置")
                            .frame(width: 120, height: 50)
                    }
                    .padding(8)
                    .padding(.leading, 10)
                }
                .background(Color(UIColor.quaternaryLabel))
                .cornerRadius(10)
                .scaleEffect(0.8)
                Button(action: {
                    if (pinCoordinate.latitude != 0.0 && pinCoordinate.longitude != 0.0 && pinDropped == true) {
                        print("pin fixed")
                        print("current latitude: \(pinCoordinate.latitude)")
                        print("current longitude: \(pinCoordinate.longitude)")
                        // TODO: dismiss window
//                        dismiss()
                    } else {
                        print("current pin location is nil")
                    }
                }) {
                    HStack {
                        Image(systemName: "checkmark")
                        Text("完了")
                            .frame(width: 120, height: 50)
                    }
                    .padding(8)
                    .padding(.leading, 10)
                }
                .foregroundColor((pinCoordinate.latitude != 0.0 && pinCoordinate.longitude != 0.0 && pinDropped == true) ? Color.white : Color.black)
                .background((pinCoordinate.latitude != 0.0 && pinCoordinate.longitude != 0.0 && pinDropped == true) ? Color.blue : Color(UIColor.quaternaryLabel))
                .cornerRadius(10)
                .scaleEffect(0.8)
            }
        }
    }

}

struct MapViewWithCross_PreviewHost: View {
    @State var pinCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    @State var pinDropped: Bool = false
    
    var body: some View {
        if #available(iOS 15.0, *) {
            MapViewWithCross(pinCoordinate: $pinCoordinate, pinDropped: $pinDropped)
        } else {
            // Fallback on earlier versions
        }
    }
}

struct MapViewWithCross_Previews: PreviewProvider {
    static var previews: some View {
        MapViewWithCross_PreviewHost()
    }
}
