//
//  Location.swift
//  LocationTracking
//
//  Created by Lam Le V. on 7/2/22.
//

import Foundation

struct Location: Codable {
    
    var lat: Double = 0
    var lng: Double = 0
    
    init(lat: Double, lng: Double) {
        self.lat = lat
        self.lng = lng
    }
}
