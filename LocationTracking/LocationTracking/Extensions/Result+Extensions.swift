//
//  Result+Extensions.swift
//  LocationTracking
//
//  Created by Lam Le V. on 7/3/22.
//

import Foundation

extension Result {

    var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
}
