//
//  TrackingView.swift
//  shopping_reminder
//
//  Created by Koichi Kishimoto on 2023/08/07.
//

import SwiftUI
import CoreLocation

struct TrackingView: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    var body: some View {
        VStack {
            Text("経度：" + String(coordinate?.longitude ?? 0))
            Text("緯度：" + String(coordinate?.latitude ?? 0))
        }
    }
    
    var coordinate: CLLocationCoordinate2D? {
        locationViewModel.lastScreenLocation?.coordinate
    }
}

struct TrackingView_Previews: PreviewProvider {
    static var previews: some View {
        TrackingView()
    }
}
