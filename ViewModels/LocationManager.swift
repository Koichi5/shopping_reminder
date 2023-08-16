//
//  File.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/08/08.
//

import Foundation
import MapKit
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var lastScreenLocation: CLLocation?
    let manager = CLLocationManager()
    var distanceFilter: CLLocationDistance = 2.0
    var regionMeters: CLLocationDistance = 1000.0
    var updateOnce: Bool = true
    
    @Published var region: MKCoordinateRegion = MKCoordinateRegion()
    
    override init() {
        authorizationStatus = manager.authorizationStatus
        
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.allowsBackgroundLocationUpdates = false
        manager.distanceFilter = distanceFilter
        self.startUpdatingLocation()
    }
    
    func requestPremission() {
        manager.requestWhenInUseAuthorization()
        manager.requestAlwaysAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastScreenLocation = locations.first
        
        DispatchQueue.main.async {
            locations.last.map {
                let center = CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude)
                self.region = MKCoordinateRegion(center: center, latitudinalMeters: self.regionMeters, longitudinalMeters: self.regionMeters)
            }
            if self.updateOnce {
                self.stopUpdatingLocation()
            }
        }
        
        guard let location = lastScreenLocation else {
            return
        }
    }
    
    func startUpdatingLocation() {
        manager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
    }
}

extension MKCoordinateRegion: Equatable {
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        return (lhs.center.latitude == rhs.center.latitude &&
                lhs.center.longitude == rhs.center.longitude &&
                lhs.span.latitudeDelta == rhs.span.latitudeDelta &&
                lhs.span.longitudeDelta == rhs.span.longitudeDelta)
    }
}

extension View {
    func sync<T: Equatable>(_ published: Binding<T>, with binding: Binding<T>) -> some View {
        self
            .onChange(of: published.wrappedValue) { published in
                if binding.wrappedValue != published {
                    binding.wrappedValue = published
                }
            }
            .onChange(of: binding.wrappedValue) { binding in
                if published.wrappedValue != binding {
                    published.wrappedValue = binding
                }
            }
    }
}
