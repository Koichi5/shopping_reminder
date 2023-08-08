//
//  Point.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/08/08.
//

import Foundation
import CoreLocation

struct Point: Identifiable {
    let id = UUID()
    let latitude: Double // 緯度
    let longitude: Double // 経度
    // 座標
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
