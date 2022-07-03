//
//  MKMapView+Extensions.swift
//  LocationTracking
//
//  Created by Lam Le V. on 7/3/22.
//

import CoreLocation
import MapKit
import UIKit

extension MKMapView {

    func centerToLocation(_ coordinate: CLLocationCoordinate2D, regionRadius: CLLocationDistance = 10_000, animated: Bool = false) {
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: animated)
    }

    func removeAllAnnotations() {
        removeAnnotations(annotations)
    }
}
