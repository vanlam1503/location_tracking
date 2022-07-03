//
//  Location.swift
//  LocationTracking
//
//  Created by Lam Le V. on 7/2/22.
//

import Foundation

struct Location {
    let lat: Double
    let lng: Double
    let description: String
}

extension Location: Equatable {
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        return (lhs.lat == rhs.lat) && (lhs.lng == rhs.lng)
    }
}
