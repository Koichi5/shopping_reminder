//
//  MapViewWithPinMode.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/08/08.
//

import SwiftUI
import MapKit


struct MapWithPinMode: View {
    @ObservedObject var locationManager: LocationManager
    
    @Binding var pinCoordinate: CLLocationCoordinate2D
    @Binding var pinDropped: Bool
//    var pinName: String
    @Binding var isPinSettingMode: Bool
    @State var region: MKCoordinateRegion = MKCoordinateRegion()
    
    var body: some View {
        if #available(iOS 17.0, *) {
            GeometryReader { geometry in
                let items: [PinLocationInfo] = pinDropped ? [PinLocationInfo(location: pinCoordinate)] : []
                ZStack (alignment: .topTrailing) {
                    Map(coordinateRegion: $region,
                        interactionModes: isPinSettingMode ? [] : . all,
                        showsUserLocation: true,
                        userTrackingMode: nil,
                        annotationItems: items,
                        annotationContent: { place in
                        MapAnnotation(coordinate: place.location, anchorPoint: CGPoint(x: 0.0, y: 0.0)) {
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
                    .sync($locationManager.region, with: $region)
                    .gesture(drag(geometry))
                    .onTapGesture { gestureValue in
                        if !isPinSettingMode {
                            return
                        }
                        print("tap fired")
                        let frame = geometry.frame(in: .local)
                        let midX = frame.midX
                        let midY = frame.midY
                        let relativeX = (gestureValue.x - midX) / frame.width
                        let relativeY = (gestureValue.y - midY) / frame.height
                        
                        print("tap gesture relativeX: \(relativeX)")
                        print("tap gesture relativeY: \(relativeY)")

                        let distanceInDegreesX = locationManager.region.span.longitudeDelta * relativeX
                        let distanceInDegreesY = locationManager.region.span.latitudeDelta * relativeY
                        pinCoordinate = CLLocationCoordinate2D(latitude: locationManager.region.center.latitude - distanceInDegreesY,
                                                               longitude: locationManager.region.center.longitude + distanceInDegreesX)
                        pinDropped = true
                    }
                    Button(action: {
                        locationManager.startUpdatingLocation()
                    }) {
                        Image(systemName: "location.circle.fill")
                            .foregroundColor(Color.blue)
                            .scaleEffect(1.5)
                    }
                    .padding()
                }
            }
            .onAppear {
                isPinSettingMode = true
            }
            .onDisappear {
                isPinSettingMode = false
            }
        } else {
            VStack {
                HStack {
                    Spacer()
                    Text("ピンモードはiOS17.0以上で使用可能です")
                    Spacer()
                }
            }
        }
    }
    
    func drag(_ geometry: GeometryProxy) -> some Gesture {
        return DragGesture()
            .onChanged { gestureValue in
                if !isPinSettingMode {
                    return
                }
                let frame = geometry.frame(in: .local)
                let midX = frame.midX
                let midY = frame.midY
                let relativeX = (gestureValue.location.x - midX) / frame.width
                let relativeY = (gestureValue.location.y - midY) / frame.height
                
                print("drag gesture relativeX: \(relativeX)")
                print("drag gesture relativeY: \(relativeY)")
                
                let distanceInDegreesX = locationManager.region.span.longitudeDelta * relativeX
                let distanceInDegreesY = locationManager.region.span.latitudeDelta * relativeY
                pinCoordinate = CLLocationCoordinate2D(latitude: locationManager.region.center.latitude - distanceInDegreesY,
                                                       longitude: locationManager.region.center.longitude + distanceInDegreesX)
            }
//            .onEnded { gestureValue in
//                isPinDraggingMode = false
//            }
    }
}

struct MapViewWithPinMode: View {
    @StateObject var locationManager = LocationManager()
    
    @Binding var pinCoordinate: CLLocationCoordinate2D
    @Binding var pinDropped: Bool
//    var pinName: String
    @State var isPinSettingMode: Bool = false
    
    var body: some View {
        VStack {
            MapWithPinMode(locationManager: locationManager, pinCoordinate: $pinCoordinate, pinDropped: $pinDropped, isPinSettingMode: $isPinSettingMode)
            HStack {
                Button(action: {
                    isPinSettingMode.toggle()
                }){
                    HStack {
                        Image(systemName: isPinSettingMode ? "mappin.circle.fill" : "map.circle.fill")
                        Text(isPinSettingMode ? "ピンモード" : "地図モード")
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


struct MapViewWithPinMode_PreviewHost: View {
    @State var pinCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    @State var pinDropped: Bool = false
    
    var body: some View {
        MapViewWithPinMode(pinCoordinate: $pinCoordinate, pinDropped: $pinDropped)
    }
}

struct MapViewWithPinMode_Previews: PreviewProvider {
    static var previews: some View {
        MapViewWithPinMode_PreviewHost()
    }
}
